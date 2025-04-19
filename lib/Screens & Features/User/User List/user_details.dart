import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../Core/Snackbar/custom_snackbars.dart';
import '../../../DesignPatterns/ProxyRoleManagement/proxy_rolemanagement.dart';

class UserDetailsPage extends StatelessWidget {
  final String userType;
  final Map<String, String> userDetails;

  const UserDetailsPage({
    super.key,
    required this.userType,
    required this.userDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$userType Details'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Type: $userType',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: userDetails.length,
                itemBuilder: (context, index) {
                  String key = userDetails.keys.elementAt(index);
                  String value = userDetails[key]!;

                  final hospitalSystem = HospitalProxy(role: userType.toLowerCase(), userId: userDetails['id'] ?? '');
                  bool isFieldRestricted = hospitalSystem.viewPatientData(key.toLowerCase(), false, context);

                  if(isFieldRestricted == false){
                    return ListTile(
                      title: Text(key, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(value),
                      leading: const Icon(Icons.info_outline),
                    );
                  }
                  else{
                    return SizedBox();
                  }

                },
              ),
            ),

            if(userType == 'Doctor' || userType == 'Staff')...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if(userDetails['verified'] == 'true') {
                      CustomSnackBar().openErrorSnackBar(context, "User is already verified.");
                      return;
                    }
                    else {
                      final validatorRole = await FirebaseFirestore.instance
                          .collection('user')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .get()
                          .then((value) => value.data()!['role']);
                      print(validatorRole);
                      final hospitalProxySystem = HospitalProxy(role: validatorRole, userId: userDetails['id'] ?? '');
                      hospitalProxySystem.verifyUser(validatorRole, userDetails['id'] ?? '', context);
                    }
                  },
                  child: const Text('Validate'),
                ),
              )
            ],
          ],
        ),
      ),
    );
  }
}