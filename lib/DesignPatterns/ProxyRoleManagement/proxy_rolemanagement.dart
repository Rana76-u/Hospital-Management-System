// Used in User List/user_details --> hospitalProxySystem.verifyUser()
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../Core/Snackbar/custom_snackbars.dart';

// Subject Interface
abstract class SystemAccess {
  void verifyUser(String validatorRole, String userId, BuildContext context);
  bool viewPatientData(String patientId, bool isRestricted, BuildContext context);
  void manageAppointments(BuildContext context);
  void viewPrescriptions(String patientId, BuildContext context);
}

// Real Subject
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
  void manageAppointments(BuildContext context) {
    CustomSnackBar().openIconSnackBar(
      context,
      'Staff will manage appointments',
      Icon(Icons.done, color: Colors.white),
    );
  }

  @override
  void viewPrescriptions(String patientId, BuildContext context) {
    CustomSnackBar().openIconSnackBar(
      context,
      '💊 Viewing prescriptions for patient \$patientId.',
      Icon(Icons.done, color: Colors.white),
    );
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
  void manageAppointments(BuildContext context) {
    if (role == "Admin" || role == "Doctor" || role == "Employee") {
      _realSystem.manageAppointments(context);
    } else {
      print("❌ Access Denied: You cannot manage appointments.");
    }
  }

  @override
  void viewPrescriptions(String patientId,BuildContext context) {
    if (role == "Admin" || role == "Doctor" || (role == "Patient" && patientId == userId)) {
      _realSystem.viewPrescriptions(patientId, context);
    } else {
      print("❌ Access Denied: You cannot view these prescriptions.");
    }
  }
}
