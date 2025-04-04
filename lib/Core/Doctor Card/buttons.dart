import 'package:caresync_hms/Core/Theme/app_color.dart';
import 'package:flutter/material.dart';

Widget bookAppointmentButton() {
  return Padding(
    padding: const EdgeInsets.only(left: 8, right: 8),
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
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