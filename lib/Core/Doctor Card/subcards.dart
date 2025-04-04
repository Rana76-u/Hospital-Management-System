import 'package:flutter/material.dart';

Widget subCards(String topicName, String value) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            topicName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              overflow: TextOverflow.clip,
            ),
          ),
        ],
      ),
    ),
  );
}