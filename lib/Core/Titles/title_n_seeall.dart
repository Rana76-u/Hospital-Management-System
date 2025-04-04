import 'package:flutter/material.dart';
import '../Theme/app_color.dart';

Widget titleAndSeeAllWidget(String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

        GestureDetector(
          child: Text(
            'See All',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColor.primaryColorBlue,
            ),
          ),
        )
      ],
    ),
  );
}