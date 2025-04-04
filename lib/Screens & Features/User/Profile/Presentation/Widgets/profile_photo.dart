import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget profilePhoto() {
  return Container(
    height: 100,
    width: 100,
    decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue.shade100,
          width: 3,
        ),
        shape: BoxShape.circle
    ),
    child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Image.network(
          FirebaseAuth.instance.currentUser!.photoURL ?? "",
          height: 100,
          fit: BoxFit.cover,
        )
    ),
  );
}