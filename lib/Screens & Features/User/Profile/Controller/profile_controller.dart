import 'package:flutter/material.dart';

class ProfileControllers {
  // Common
  final name = TextEditingController();
  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  final gender = TextEditingController();
  final role = TextEditingController();

  // Patient
  final bloodGroup = TextEditingController();
  final emergencyContact = TextEditingController();
  final medicalHistory = TextEditingController();
  final currentMedications = TextEditingController();

  // Doctor
  final specialization = TextEditingController();
  final licence = TextEditingController();
  final experience = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedFromTime;
  TimeOfDay? selectedUntilTime;
  final fee = TextEditingController();

  // Staff
  final department = TextEditingController();
  final designation = TextEditingController();
  final shift = TextEditingController();
  final salary = TextEditingController();

  // Admin
  final access = TextEditingController();

  void dispose() {
    name.dispose();
    email.dispose();
    phoneNumber.dispose();
    gender.dispose();
    role.dispose();
    bloodGroup.dispose();
    emergencyContact.dispose();
    medicalHistory.dispose();
    currentMedications.dispose();
    specialization.dispose();
    licence.dispose();
    experience.dispose();
    fee.dispose();
    department.dispose();
    designation.dispose();
    shift.dispose();
    salary.dispose();
    access.dispose();
  }
}
