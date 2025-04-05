import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppointmentRepository {

  Future<void> createAppointment(
      String doctorId,
      String patientId,
      DateTime? appointmentDatetime,
      String reason,
  ) async {
    FirebaseFirestore.instance.collection('appointments').doc().set({
      'doctorId': doctorId,
      'patientId': patientId,
      'appointmentDatetime': appointmentDatetime,
      'status': 'sheduled',
      'reason': reason,
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
    }).then((_) {
      print('Appointment created successfully');
    }).catchError((error) {
      print('Failed to create appointment: $error');
    });
  }

  Future<DateTime?> pickDate(BuildContext context, DateTime? currentDate) async {
    final now = DateTime.now();
    return await showDatePicker(
      context: context,
      initialDate: currentDate ?? now,
      firstDate: now,
      lastDate: now.add(Duration(days: 30)),
    );
  }

  Future<TimeOfDay?> pickTime(BuildContext context, TimeOfDay? currentTime) async {
    return await showTimePicker(
      context: context,
      initialTime: currentTime ?? TimeOfDay.now(),
    );
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'Select Date';
    return '${date.day}/${date.month}/${date.year}';
  }

  String formatTime(TimeOfDay? time) {
    if (time == null) return 'Select Time';
    final hour = time.hourOfPeriod.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  DateTime? createDateTime(DateTime? date, TimeOfDay? time) {
    if (date == null || time == null) return null;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}
