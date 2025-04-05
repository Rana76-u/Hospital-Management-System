import 'package:caresync_hms/Core/Doctor%20Card/buttons.dart';
import 'package:caresync_hms/Core/Doctor%20Card/specialization_widget.dart';
import 'package:caresync_hms/Core/Doctor%20Card/subcards.dart';
import 'package:caresync_hms/Core/Doctor%20Card/top_profile_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DoctorCard extends StatelessWidget {
  final String doctorId;
  final bool showButton;
  const DoctorCard({super.key, required this.doctorId, required this.showButton});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection('user').doc(doctorId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading doctor data'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Doctor not found'));
          }

          final doctorsImage = snapshot.data!.get('photo');
          final doctorsPhoneNumber = snapshot.data!.get('phone');
          final doctorName = snapshot.data!.get('name');
          final doctorsSpecialization = snapshot.data!.get('specialization');
          final doctorsExperience = snapshot.data!.get('experience_level');
          final doctorsAvailability = snapshot.data!.get('availability');
          final doctorsFee = snapshot.data!.get('consultation_fee').toString();

          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                topProfileWidget(doctorsImage, doctorName, doctorsPhoneNumber),
                specializationWidget(doctorsSpecialization),

                cardWidgets(doctorsExperience, doctorsAvailability, doctorsFee,),

                showButton ? bookAppointmentButton(context, doctorId) : SizedBox(),
              ],
            ),
          );
        },
    );
  }

  Widget cardWidgets(String doctorsExperience, String doctorsAvailability, String doctorsFee,) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            subCards('Experience', doctorsExperience),
            const SizedBox(width: 3),
            subCards('Available Time', doctorsAvailability),
            const SizedBox(width: 3),
            subCards('Consultation Fee', doctorsFee),
          ],
        ),
      ),
    );
  }
}
