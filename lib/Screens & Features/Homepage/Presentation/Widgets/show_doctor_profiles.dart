import 'package:caresync_hms/Core/Titles/title_n_seeall.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../../../Core/Doctor Card/doctor_card.dart';

Widget showDoctorProfiles() {
  return Column(
    children: [
      titleAndSeeAllWidget('Featured Doctors'),
      CarouselSlider(
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
        items: ['dmHRWKCEI9YWdM8wbbpUBmXXhIC2'].map((i) {
          return Builder(
            builder: (BuildContext context) {
              return DoctorCard(doctorId: 'dmHRWKCEI9YWdM8wbbpUBmXXhIC2');
            },
          );
        }).toList(),
      )
    ],
  );
}