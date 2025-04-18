// Flutter imports:
import 'package:caresync_hms/Screens%20&%20Features/Appointment/Presentation/appointment_page.dart';
import 'package:caresync_hms/Screens%20&%20Features/User/Doctor/home_doctor.dart';
import 'package:caresync_hms/Screens%20&%20Features/User/Patient/patient_dashboard.dart';
import 'package:caresync_hms/Screens%20&%20Features/Notification/Presentation/notification_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../Screens & Features/User/Admin/admin_dashboard.dart';
import '../../../Screens & Features/User/Profile/Presentation/profile.dart';

// Project imports:
Widget bottomBarBuildBody(BuildContext context, int index, String userType) {
  //checkUserType(context);
  return FutureBuilder(
    future: FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return const Center(child: Text('Error loading data'));
      }
      if (!snapshot.hasData) {
        return const Center(child: Text('No data found'));
      }
      userType = snapshot.data!['role'];
      switch (index) {
        case 0:
          if(userType == 'doctor') {
            return const DoctorDashboardPage();
          }
          else if(userType == 'patient') {
            return const PatientDashboard();
          }
          else if(userType == 'admin') {
            return const AdminDashboard();
          }
          else {
            return const SizedBox();
          }
        case 1:
          return const AppointmentPage();
        case 2:
          return NotificationPage();
        case 3:
          return ProfileScreen();
        default:
          return const SizedBox();
      }
    },
  );
}
