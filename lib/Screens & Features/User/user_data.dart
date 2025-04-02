import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Profile/Controller/profile_controller.dart';

class UserRepository {
  Future<bool> checkUserExists(String userId) async {
    DocumentSnapshot documentSnapshot =
    await FirebaseFirestore.instance.collection('user').doc(userId).get();

    return documentSnapshot.exists;
  }

  Future<void> createNewUser(String userType) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    Map<String, dynamic> commonFields = {
      'name': user.displayName,
      'email': user.email,
      'phone': user.phoneNumber ?? '',
      'photo': user.photoURL,
      'gender': '',
      'role': userType,
    };

    Map<String, dynamic> roleSpecificFields = {};

    switch (userType) {
      case 'patient':
        roleSpecificFields = {
          'blood_group': '',
          'emergency_contact': '',
          'medical_history': '',
          'current_medications': ''
        };
        break;
      case 'doctor':
        roleSpecificFields = {
          'specialization': '',
          'licence_number': '',
          'experience_level': '',
          'availability': '',
          'consultation_fee': 0
        };
        break;
      case 'staff':
        roleSpecificFields = {
          'department': '',
          'designation': '',
          'shift': '',
          'salary': ''
        };
        break;
      case 'admin':
        roleSpecificFields = {
          'access_level': ''
        };
        break;
    }

    await FirebaseFirestore.instance
        .collection('user')
        .doc(user.uid)
        .set({...commonFields, ...roleSpecificFields});
  }

  static Future<void> updateUserProfile(String userId, ProfileControllers controllers) async {
    Map<String, dynamic> updatedCommonInfo = {
      'name': controllers.name.text,
      'email': controllers.email.text,
      'phone': controllers.phoneNumber.text,
      'gender': controllers.gender.text,
    };

    Map<String, dynamic> updatedRoleSpecificFields = _getRoleSpecificFields(controllers);

    await FirebaseFirestore.instance.collection('user').doc(userId).update({
      ...updatedCommonInfo,
      ...updatedRoleSpecificFields,
    });
  }

  static Map<String, dynamic> _getRoleSpecificFields(ProfileControllers controllers) {
    switch (controllers.role.text) {
      case 'patient':
        return {
          'blood_group': controllers.bloodGroup.text,
          'emergency_contact': controllers.emergencyContact.text,
          'medical_history': controllers.medicalHistory.text,
          'current_medications': controllers.currentMedications.text,
        };
      case 'doctor':
        return {
          'specialization': controllers.specialization.text,
          'licence_number': controllers.licence.text,
          'experience_level': controllers.experience.text,
          'availability': controllers.availability.text,
          'consultation_fee': int.tryParse(controllers.fee.text) ?? 0,
        };
      case 'staff':
        return {
          'department': controllers.department.text,
          'designation': controllers.designation.text,
          'shift': controllers.shift.text,
          'salary': int.tryParse(controllers.salary.text) ?? 0,
        };
      case 'admin':
        return {
          'access_level': controllers.access.text,
        };
      default:
        return {};
    }
  }

}