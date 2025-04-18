import 'package:caresync_hms/Screens%20&%20Features/Appointment/Repository/create_appointment_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../../Core/Snackbar/custom_snackbars.dart';
import '../../../../../Core/TextBox/custom_input_field.dart';
import '../../Controller/profile_controller.dart';

class ProfileInputFields extends StatefulWidget {
  final ProfileControllers controllers;

  const ProfileInputFields({super.key, required this.controllers});

  @override
  _ProfileInputFieldsState createState() => _ProfileInputFieldsState();
}

class _ProfileInputFieldsState extends State<ProfileInputFields> {


  final createAppointmentRepo = AppointmentUIUtility();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore
            .instance
            .collection('user')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: LinearProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          }
          else if(snapshot.hasError){
            return CustomSnackBar().openErrorSnackBar(context, 'Error Loading Data, Please try again later');
          }
          else {
            widget.controllers.name.text = snapshot.data!.get('name');
            widget.controllers.email.text = snapshot.data!.get('email');
            widget.controllers.phoneNumber.text = snapshot.data!.get('phone').toString();
            widget.controllers.gender.text = snapshot.data!.get('gender');
            widget.controllers.role.text = snapshot.data!.get('role');

            if(snapshot.data!.get('role') == 'patient'){
              widget.controllers.bloodGroup.text = snapshot.data!.get('blood_group');
              widget.controllers.emergencyContact.text = snapshot.data!.get('emergency_contact');
              widget.controllers.medicalHistory.text = snapshot.data!.get('medical_history');
              widget.controllers.currentMedications.text = snapshot.data!.get('current_medications');
            } else if(snapshot.data!.get('role') == 'doctor'){
              widget.controllers.specialization.text = snapshot.data!.get('specialization');
              widget.controllers.licence.text = snapshot.data!.get('licence_number');
              widget.controllers.experience.text = snapshot.data!.get('experience_level');
              //widget.controllers.availableFrom = snapshot.data!.get('availableFrom');
              //widget.controllers.availableUntil = snapshot.data!.get('availableUntil');
              widget.controllers.selectedDate = snapshot.data!.get('availableFrom').toDate();
              widget.controllers.selectedFromTime = TimeOfDay.fromDateTime(snapshot.data!.get('availableFrom').toDate());
              widget.controllers.selectedUntilTime = TimeOfDay.fromDateTime(snapshot.data!.get('availableUntil').toDate());
              widget.controllers.fee.text = snapshot.data!.get('consultation_fee').toString();
            } else if(snapshot.data!.get('role') == 'staff'){
              widget.controllers.department.text = snapshot.data!.get('department');
              widget.controllers.designation.text = snapshot.data!.get('designation');
              widget.controllers.shift.text = snapshot.data!.get('shift');
              widget.controllers.salary.text = snapshot.data!.get('salary').toString();
            } else if(snapshot.data!.get('role') == 'admin'){
              widget.controllers.access.text = snapshot.data!.get('access_level');
            }

            return Column(
              children: [
                CustomInputField(inputController: widget.controllers.name, fieldName: 'Name',),
                CustomInputField(inputController: widget.controllers.email, fieldName: 'Email',),
                CustomInputField(inputController: widget.controllers.phoneNumber, fieldName: 'Phone',),
                CustomInputField(inputController: widget.controllers.gender, fieldName: 'Gender',),
                if (widget.controllers.role.text == 'patient') ...[
                  CustomInputField(inputController: widget.controllers.bloodGroup, fieldName: 'Blood Group',),
                  CustomInputField(inputController: widget.controllers.emergencyContact, fieldName: 'Emergency Contact',),
                  CustomInputField(inputController: widget.controllers.medicalHistory, fieldName: 'Medical History',),
                  CustomInputField(inputController: widget.controllers.currentMedications, fieldName: 'Current Medications',),
                ] else if (widget.controllers.role.text == 'doctor') ...[
                  CustomInputField(inputController: widget.controllers.specialization, fieldName: 'Specialization',),
                  CustomInputField(inputController: widget.controllers.licence, fieldName: 'Licence Number',),
                  CustomInputField(inputController: widget.controllers.experience, fieldName: 'Experience Level',),
                  //CustomInputField(inputController: widget.controllers.availability, fieldName: 'Availability',),
                  CustomInputField(inputController: widget.controllers.fee, fieldName: 'Consultation Fee',),

                  selectDateWidget(),
                  SizedBox(height: 20),
                  selectTimeWidget('Select Available From Time:', widget.controllers.selectedFromTime!),
                  SizedBox(height: 20),
                  selectTimeWidget('Select Available Until Time:', widget.controllers.selectedUntilTime!),
                  SizedBox(height: 20),

                ] else if (widget.controllers.role.text == 'staff') ...[
                  CustomInputField(inputController: widget.controllers.department, fieldName: 'Department',),
                  CustomInputField(inputController: widget.controllers.designation, fieldName: 'Designation',),
                  CustomInputField(inputController: widget.controllers.shift, fieldName: 'Shift',),
                  CustomInputField(inputController: widget.controllers.salary, fieldName: 'Salary',),
                ] else if (widget.controllers.role.text == 'admin') ...[
                  CustomInputField(inputController: widget.controllers.access, fieldName: 'Access Level',),
                ]
              ],
            );
          }
        },
    );
  }


  Widget selectDateWidget(){
    return Row(
      children: [
        Text(
          'Select Date: ${createAppointmentRepo.formatDate(widget.controllers.selectedDate)}',
          style: const TextStyle(fontSize: 16),
          overflow: TextOverflow.ellipsis,
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () async {
            final picked = await createAppointmentRepo.pickDate(context, widget.controllers.selectedDate);
            if (picked != null) setState(() => widget.controllers.selectedDate = picked);
          },
          child: Text(createAppointmentRepo.formatDate(widget.controllers.selectedDate)),
        )
      ],
    );
  }

  Widget selectTimeWidget(String text, TimeOfDay selectedTime){
    return Row(
      children: [
        Flexible(
          child: Text(
            '$text ${createAppointmentRepo.formatTime(selectedTime)}',
            style: const TextStyle(fontSize: 16),
            overflow: TextOverflow.clip,
          ),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () async {
            final picked = await createAppointmentRepo.pickTime(context, selectedTime);
            if (picked != null) setState(() => selectedTime = picked);
          },
          child: Text(createAppointmentRepo.formatTime(selectedTime)),
        )
      ],
    );
  }
}
