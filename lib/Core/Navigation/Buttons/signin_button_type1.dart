import 'package:flutter/material.dart';

Widget signInUsingGoogleButtonType1(BuildContext context) {
  return SizedBox(
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: WidgetStateColor.resolveWith((states) => Colors.black),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
        ),
      ),
      onPressed: () {
        //open login page
        //todo: Skipped Not Necessary
      },
      child: const Text(
        'Sign in using Google',
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13
        ),
      ),
    ),
  );
}