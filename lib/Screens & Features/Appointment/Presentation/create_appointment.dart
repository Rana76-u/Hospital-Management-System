import 'package:caresync_hms/Core/Doctor%20Card/doctor_card.dart';
import 'package:caresync_hms/Core/TextBox/custom_input_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Repository/create_appointment_repo.dart';

class CreateAppointment extends StatefulWidget {
  final String doctorId;
  const CreateAppointment({super.key, required this.doctorId});

  @override
  State<CreateAppointment> createState() => _CreateAppointmentState();
}

class _CreateAppointmentState extends State<CreateAppointment> {
  final createAppointmentRepo = AppointmentRepository();
  final String patientId = FirebaseAuth.instance.currentUser!.uid;

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final TextEditingController reasonController = TextEditingController();

  void bookAppointment() {
    final dateTime = createAppointmentRepo.createDateTime(selectedDate, selectedTime);
    if (dateTime != null) {
      createAppointmentRepo.createAppointment(widget.doctorId, patientId, dateTime, reasonController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment booked on $dateTime')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select both date and time')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Appointment'),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              'Book an appointment with the doctor',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DoctorCard(doctorId: widget.doctorId, showButton: false),
                  // Add date time picker, patient details, etc.
                  const SizedBox(height: 20),

                  selectDateWidget(),
                  SizedBox(height: 20),
                  selectTimeWidget(),
                  SizedBox(height: 40),
                  CustomInputField(inputController: reasonController, fieldName: 'Reason for Appointment'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: bookAppointment,
                    child: Text('Confirm Appointment'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget selectDateWidget(){
    return Row(
      children: [
        Text(
          'Select Date: ${createAppointmentRepo.formatDate(selectedDate)}',
          style: const TextStyle(fontSize: 16),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () async {
            final picked = await createAppointmentRepo.pickDate(context, selectedDate);
            if (picked != null) setState(() => selectedDate = picked);
          },
          child: Text(createAppointmentRepo.formatDate(selectedDate)),
        )
      ],
    );
  }

  Widget selectTimeWidget(){
    return Row(
      children: [
        Text(
          'Select Time: ${createAppointmentRepo.formatTime(selectedTime)}',
          style: const TextStyle(fontSize: 16),
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
