import 'package:caresync_hms/Core/Titles/title_n_seeall.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../Core/Doctor Card/doctor_card.dart';

Widget showDoctorProfileSlider() {
  return Column(
    children: [
      titleAndSeeAllWidget('Featured Doctors'),
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
          return CarouselSlider(
            options: CarouselOptions(
              height: 268,
              viewportFraction: 1,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 4),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0.25,
              scrollDirection: Axis.horizontal,
            ),
            items: (snapshot.data!.docs as List<QueryDocumentSnapshot>).map((doc) {
              return Builder(
                builder: (BuildContext context) {
                  return DoctorCard(doctorId: doc.id, showButton: true);
                },
              );
            }).toList(),
          );
        },
      )
    ],
  );
}