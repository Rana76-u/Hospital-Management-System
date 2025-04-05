import 'package:caresync_hms/Core/Theme/app_color.dart';
import 'package:flutter/material.dart';

import '../../Screens & Features/Appointment/Presentation/create_appointment.dart';

Widget bookAppointmentButton(BuildContext context, String doctorId) {
  return Padding(
    padding: const EdgeInsets.only(left: 8, right: 8),
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return CreateAppointment(doctorId: doctorId);
            },)
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primaryColorBlue,
          //padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          'Book An Appointment',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    ),
  );
}