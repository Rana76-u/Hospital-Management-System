import 'package:caresync_hms/Core/Titles/title_n_seeall.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../Core/Doctor Card/doctor_card.dart';

Widget showDoctorProfileColumn() {
  return Column(
    children: [
      titleAndSeeAllWidget('All Doctors'),
      FutureBuilder(
        future: FirebaseFirestore.instance.collection('user')
            .where('role', isEqualTo: 'doctor').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data found'));
          }
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              return DoctorCard(doctorId: doc.id, showButton: true);
            },
          );
        },
      )
    ],
  );
}