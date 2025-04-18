import 'package:caresync_hms/Core/Bottom%20Navigation/Bloc/bottom_bar_bloc.dart';
import 'package:caresync_hms/Core/Bottom%20Navigation/Bloc/bottom_bar_events.dart';
import 'package:caresync_hms/Screens%20&%20Features/User/User%20List/list_of_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DoctorDashboardPage extends StatelessWidget {
  const DoctorDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('user').doc(FirebaseAuth.instance.currentUser!.uid).get(),
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
        final userData = snapshot.data!;
        final userName = userData['name'] ?? '';
        return Scaffold(
          appBar: AppBar(
            title: Text("👋 Welcome, $userName", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            automaticallyImplyLeading: false,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 16),

                // Today’s Appointments
                FutureBuilder(
                  future: FirebaseFirestore.instance.collection('appointments')
                      .where('doctorID', isEqualTo: FirebaseAuth.instance.currentUser!.uid).get(),
                  builder: (context, appointmentSnapshot) {
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("📅 Today's Appointments", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: appointmentSnapshot.data?.docs.length ?? 0,
                              itemBuilder: (context, index) {
                                final appointment = appointmentSnapshot.data!.docs[index];
                                final patientId = appointment['patientID'] ?? 'Unknown';
                                final DateTime appointmentDatetime = DateTime.parse(appointment['appointmentDatetime'].toDate().toString());
                                final appointmentStatus = appointment['status'] ?? 'Pending';

                                final DateFormat formatter = DateFormat('d MMMM y \'at\' hh:mm a');
                                return ListTile(
                                  leading: CircleAvatar(child: Icon(Icons.person)),
                                  title: FutureBuilder(
                                    future: FirebaseFirestore
                                        .instance.collection('user')
                                        .doc(patientId).get(),
                                    builder: (context, patientSnapshot) {
                                      return Text(patientSnapshot.data?['name'] ?? 'Unknown');
                                    },
                                  ),
                                  subtitle: Text(formatter.format(appointmentDatetime)),
                                  trailing: Chip(label: Text(appointmentStatus)),
                                );
                              },
                            )
                          ],
                        ),

                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Patient Stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _StatCard(title: "Patients", count: 24),
                    _StatCard(title: "Upcoming", count: 5),
                    _StatCard(title: "Feedbacks", count: 12),
                  ],
                ),

                const SizedBox(height: 24),

                // Notifications
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("⚠️ Notifications", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        SizedBox(height: 8),
                        ListTile(
                          leading: Icon(Icons.notifications, color: Colors.red),
                          title: Text("Appointment with Md. Rafiqul Islam is rescheduled"),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Appointment Management & More
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _DashboardTile(icon: Icons.calendar_today, label: 'Appointments'),
                    _DashboardTile(icon: Icons.people, label: 'Patients'),
                    _DashboardTile(icon: Icons.chat, label: 'Chat'),
                    _DashboardTile(icon: Icons.receipt, label: 'Prescriptions'),
                    _DashboardTile(icon: Icons.bar_chart, label: 'Analytics'),
                    _DashboardTile(icon: Icons.settings, label: 'Settings'),
                  ],
                ),

                const SizedBox(height: 50),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final int count;

  const _StatCard({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text('$count', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis)),
            const SizedBox(height: 6),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class _DashboardTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const _DashboardTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(label == 'Patients'){
          Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ListOfUser(userType: 'patient'),
              )
          );
        }
        else if(label == 'Appointments'){
          BlocProvider.of<BottomBarBloc>(context).add(BottomBarSelectedItem(1));
        }
        else if(label == 'Settings'){
          BlocProvider.of<BottomBarBloc>(context).add(BottomBarSelectedItem(3));
        }

      },
      child: Container(
        width: 120,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.blue),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
