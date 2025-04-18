import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'user_details.dart';

class ListOfUser extends StatelessWidget {
  final String userType ;
  const ListOfUser({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Users'),
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder(
          future: FirebaseFirestore.instance.collection('user').where('role', isEqualTo: userType).get(),
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
            final userList = snapshot.data!.docs;
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: userList.length,
              itemBuilder: (context, index) {
                final user = userList[index];
                return GestureDetector(
                  onTap: () {
                    String userTypeToDisplay = '';
                    Map<dynamic, dynamic> userDetailsBasic ={
                      'id': user.id,
                      'name': user['name'],
                      'email': user['email'],
                      'phone': user['phone'],
                      'gender': user['gender'],
                      'role': user['role'],
                      'photoUrl': user['photoUrl'],
                    };
                    Map<dynamic, dynamic> userDetailsSpecific = {};
                    if(userType == 'doctor'){
                      userTypeToDisplay = 'Doctor';
                      userDetailsSpecific = {
                        'specialization': user['specialization'],
                        'licence_number': user['licence_number'],
                        'experience_level': user['experience_level'],
                        //'availableFrom': user['availableFrom'],
                        //'availableUntil': user['availableUntil'],
                        'consultation_fee': user['consultation_fee'].toString(),
                        'verified': user['verified'].toString(),
                      };
                    } else if(userType == 'patient'){
                      userTypeToDisplay = 'Patient';
                      userDetailsSpecific = {
                        'blood_group': user['blood_group'],
                        'emergency_contact': user['emergency_contact'],
                        'medical_history': user['medical_history'],
                        'current_medications': user['current_medications'],
                      };
                    } else if(userType == 'employee'){
                      userTypeToDisplay = 'Employee';
                      userDetailsSpecific = {
                        'department': user['department'],
                        'designation': user['designation'],
                        'shift': user['shift'],
                        'salary': user['salary'],
                      };
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDetailsPage(
                          userType: userTypeToDisplay,
                            userDetails: {
                              ...userDetailsBasic,
                              ...userDetailsSpecific,
                            }
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      title: Text(user['name']),
                      subtitle: Text(user['email']),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
