// Used in create_appointment.dart - facade.bookAppointment()
import 'package:caresync_hms/DesignPatterns/ObserverAppointmentNotifications/observer_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../Core/Snackbar/custom_snackbars.dart';

// Models
class Patient {
  final String patientID;
  final String name;

  Patient(this.patientID, this.name);
}

class Doctor {
  final String doctorID;
  final String name;
  final String specialization;

  Doctor(this.doctorID, this.name, this.specialization);
}

class Appointment {
  final String patientID;
  final String doctorID;
  final DateTime datetime;
  String status;
  final String reason;

  Appointment({
    required this.patientID,
    required this.doctorID,
    required this.datetime,
    required this.reason,
    this.status = 'Scheduled',
  });

  Map<String, dynamic> toJson() => {
    'patientID': patientID,
    'doctorID': doctorID,
    'appointmentDatetime': datetime,
    'status': status,
    'reason': reason,
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
    'paymentStatus': 'Pending',
  };

  void updateStatus(String newStatus) {
    status = newStatus;
    print('Appointment status updated to: \$status');
  }

  @override
  String toString() {
    return 'Appointment(patientID: \$patientID, doctorID: \$doctorID, datetime: \$datetime, status: \$status, reason: \$reason)';
  }
}

// Subsystem
class AppointmentRecordService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createAppointmentRecord({
    required String patientID,
    required String doctorID,
    required DateTime datetime,
    required String reason,
  }) async {
    final appointment = Appointment(
      patientID: patientID,
      doctorID: doctorID,
      datetime: datetime,
      reason: reason,
    );

    final docRef = await _firestore.collection('appointments').add(appointment.toJson());
    final docId = docRef.id;

    print('Created appointment record in Firestore: \$appointment');
    return docId;
  }

  Future<void> updateAppointmentStatus(String appointmentID, String newStatus) async {
    await _firestore.collection('appointments').doc(appointmentID).update({
      'status': newStatus,
      'updatedAt': DateTime.now(),
    });
    print('Updated appointment \$appointmentID status to: \$newStatus');
  }

  Future<void> updateAppointmentTime(String appointmentID, DateTime newDatetime) async {
    await _firestore.collection('appointments').doc(appointmentID).update({
      'appointmentDatetime': newDatetime,
      'updatedAt': DateTime.now(),
    });
    print('Updated appointment \$appointmentID time to: \$newDatetime');
  }
}

// Subsystem
class DoctorAvailabilityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> isDoctorAvailable(String doctorId, DateTime requestedTime) async {
    try {
      final userDoc = await _firestore.collection('user').doc(doctorId).get();

      if (!userDoc.exists) {
        print('Doctor \$doctorId does not exist in the system');
        return false;
      }

      final data = userDoc.data()!;
      final DateTime availableFrom = (data['availableFrom'] as Timestamp).toDate();
      final DateTime availableUntil = (data['availableUntil'] as Timestamp).toDate();

      if (requestedTime.isBefore(availableFrom) || requestedTime.isAfter(availableUntil)) {
        print('Doctor \$doctorId is unavailable at \$requestedTime (outside available hours)');
        return false;
      }

      final conflictingAppointments = await _firestore
          .collection('appointments')
          .where('doctorID', isEqualTo: doctorId)
          .where('appointmentDatetime', isEqualTo: requestedTime)
          .get();

      if (conflictingAppointments.docs.isNotEmpty) {
        print('Doctor \$doctorId already has an appointment at \$requestedTime');
        return false;
      }

      print('Doctor \$doctorId is available at \$requestedTime');
      return true;
    } catch (e) {
      print('Error checking availability: \$e');
      return false;
    }
  }
}

// Facade
class AppointmentFacade {
  final DoctorAvailabilityService _availabilityService = DoctorAvailabilityService();
  final AppointmentRecordService _recordService = AppointmentRecordService();

  Future<String?> bookAppointment({
    required String patientID,
    required String doctorID,
    required DateTime datetime,
    required String reason,
    required BuildContext context,
  }) async {
    print('\n--- BOOKING APPOINTMENT ---');

    final available = await _availabilityService.isDoctorAvailable(doctorID, datetime);
    if (!available) {
      print('Cannot book appointment: Doctor not available');
      return null;
    }

    final appointment = await _recordService.createAppointmentRecord(
      patientID: patientID,
      doctorID: doctorID,
      datetime: datetime,
      reason: reason,
    );

    CustomSnackBar().openPrimarySnackBar(context, "Appointment Booked Successfully");
    // Notify observers here
    CustomSnackBar().openPrimarySnackBar(context, "✅ Appointment Booked Successfully");


    // Notify observers
    // Subject of the Observer Pattern
    AppointmentNotification appointmentNotification = AppointmentNotification(appointment);
    appointmentNotification.addObserver(ObserverDoctor(doctorID));
    appointmentNotification.addObserver(ObserverPatient(patientID));
    appointmentNotification.setStatus("Scheduled");
    appointmentNotification.clearObservers();

    return appointment;
  }

  Future<bool> cancelAppointment(String appointmentID) async {
    print('\n--- CANCELING APPOINTMENT ---');

    await _recordService.updateAppointmentStatus(appointmentID, 'Canceled');
    print('Appointment successfully canceled!');
    return true;
  }
}