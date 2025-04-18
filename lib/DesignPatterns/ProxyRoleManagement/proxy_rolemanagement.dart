// Abstract Interface
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../Core/Snackbar/custom_snackbars.dart';

abstract class SystemAccess {
  void verifyUser(String validatorRole, String userId, BuildContext context);
  bool viewPatientData(String patientId, bool isRestricted, BuildContext context);
  void manageAppointments();
  void viewPrescriptions(String patientId);
}

// Real Implementation
class HospitalSystem implements SystemAccess {
  @override
  void verifyUser(String validatorRole, String userId, context) async {
    await FirebaseFirestore.instance.collection('user').doc(userId).update({
      'verified': true,
    });

    CustomSnackBar().openIconSnackBar(
      context,
      'User Verified Successfully',
      Icon(Icons.done, color: Colors.white),
    );
  }

  @override
  bool viewPatientData(String fieldName, bool isRestricted, BuildContext context) {
    if(isRestricted){
      switch(fieldName){
        case 'name':
          return false;
        case 'email':
          return false;
        default:
          return true;
      }
    }
    else{
      return false;
    }
  }

  @override
  void manageAppointments() {
    print("📅 Managing appointments...");
  }

  @override
  void viewPrescriptions(String patientId) {
    print("💊 Viewing prescriptions for patient \$patientId.");
  }
}

// Proxy with Role-Based Access Control
class HospitalProxy implements SystemAccess {
  final String role; // "Admin", "Doctor", "Employee", "Patient"
  final String userId;
  final HospitalSystem _realSystem = HospitalSystem();

  HospitalProxy({required this.role, required this.userId});

  @override
  void verifyUser(String validatorRole, String userId, context) {
    if (role == "admin") {
      _realSystem.verifyUser(validatorRole, userId, context);
    } else {
      CustomSnackBar().openErrorSnackBar(context, "You are not authorized to verify users.");
    }
  }

  @override
  bool viewPatientData(String fieldName, bool isRestricted, BuildContext context) {
    if (role == "admin" || role == "doctor" || role == "patient") {
      return _realSystem.viewPatientData(fieldName, false, context);
    }
    else if(role == 'staff') {
      return _realSystem.viewPatientData(fieldName, true, context);
    }
    else {
      CustomSnackBar().openErrorSnackBar(context, "❌ Access Denied: You cannot view this medical history.");
      return false;
    }
  }

  @override
  void manageAppointments() {
    if (role == "Admin" || role == "Doctor" || role == "Employee") {
      _realSystem.manageAppointments();
    } else {
      print("❌ Access Denied: You cannot manage appointments.");
    }
  }

  @override
  void viewPrescriptions(String patientId) {
    if (role == "Admin" || role == "Doctor" || (role == "Patient" && patientId == userId)) {
      _realSystem.viewPrescriptions(patientId);
    } else {
      print("❌ Access Denied: You cannot view these prescriptions.");
    }
  }
}
