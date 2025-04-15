import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentPage extends StatelessWidget {
  const AppointmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
                future: FirebaseFirestore
                    .instance
                    .collection('appointments')
                    .where('patientId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching appointments'));
                }
                if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No appointments found'));
                }
                final appointments = snapshot.data!.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    final appointment = appointments[index];

                    final DateTime appointmentDatetime = DateTime.parse(appointment['appointmentDatetime'].toDate().toString());
                    final DateTime createdAt = DateTime.parse(appointment['createdAt'].toDate().toString());
                    final DateTime updatedAt = DateTime.parse(appointment['updatedAt'].toDate().toString());
                    final String doctorId = appointment['doctorId'];
                    final String reason = appointment['reason'];
                    final String status = appointment['status'];

                    final DateFormat formatter = DateFormat('d MMMM y \'at\' hh:mm a');
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildRow(Icons.calendar_today, 'Appointment', formatter.format(appointmentDatetime)),
                              _buildRow(Icons.description, 'Reason', reason),
                              FutureBuilder(
                                  future: FirebaseFirestore.instance.collection('user').doc(doctorId).get(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const Center(child: CircularProgressIndicator());
                                    }
                                    if (snapshot.hasError) {
                                      return const Center(child: Text('Error fetching doctor name'));
                                    }
                                    if (snapshot.hasData && snapshot.data!.exists) {
                                      final doctorName = snapshot.data!['name'];
                                      return _buildRow(Icons.local_hospital, 'Doctor Name', doctorName);
                                    }
                                    return const SizedBox.shrink();
                                  },
                              ),
                              _buildRow(Icons.info_outline, 'Status', status),
                              _buildRow(Icons.timer, 'Created At', formatter.format(createdAt)),
                              _buildRow(Icons.update, 'Updated At', formatter.format(updatedAt)),

                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Flexible(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

}
