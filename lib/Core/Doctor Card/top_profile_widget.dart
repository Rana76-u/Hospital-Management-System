import 'package:flutter/material.dart';

Widget topProfileWidget(String doctorsImage, String doctorName, String doctorsPhoneNumber) {
  return Padding(
    padding: const EdgeInsets.only(left: 12, top: 12, bottom: 8, right: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(
              doctorsImage,
              height: 50,
              fit: BoxFit.cover,
            )
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              doctorName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              doctorsPhoneNumber,
              style: TextStyle(
                overflow: TextOverflow.clip,
              ),
            ),
          ],
        )
      ],
    ),
  );
}