import 'package:flutter/material.dart';

Widget specializationWidget(String doctorsSpecialization) {
  return Padding(
    padding: const EdgeInsets.only(left: 12, top: 8, right: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Specialization: ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          doctorsSpecialization,
          style: TextStyle(
            overflow: TextOverflow.clip,
          ),
        ),
      ],
    ),
  );
}