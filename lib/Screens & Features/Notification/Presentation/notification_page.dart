import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('notifications')
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .orderBy('timestamp', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching notifications'));
                }
                if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Text('No notifications yet.', style: Theme.of(context).textTheme.bodyLarge),
                    ),
                  );
                }
                final notifications = snapshot.data!.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];

                    final String appointmentId = notification['appointmentId'];
                    final String message = notification['message'];
                    final bool read = notification['read'];
                    //final String role = notification['role'];
                    final String status = notification['status'];
                    final DateTime timestamp = notification['timestamp'].toDate();

                    final DateFormat formatter = DateFormat('d MMM y, hh:mm a');
                    final formattedTime = formatter.format(timestamp);

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: read ? Colors.white : Colors.blue.shade50,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: Icon(
                            read ? Icons.notifications_none : Icons.notifications_active,
                            color: read ? Colors.grey : Colors.blueAccent,
                          ),
                          title: Text(
                            message,
                            style: TextStyle(
                              fontWeight: read ? FontWeight.normal : FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 6),
                              Text('Status: $status'),
                              //Text('Role: ${role.capitalize()}'),
                              Text('Appointment ID: $appointmentId'),
                              Text(formattedTime, style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                          trailing: read
                              ? null
                              : Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.redAccent,
                            ),
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
}

extension StringCasingExtension on String {
  String capitalize() => isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';
}
