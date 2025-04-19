// Used in SignUp, UserRepository().createNewUser(userType);
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Screens & Features/User/Profile/Controller/profile_controller.dart';

// Model
class Person {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String gender;
  final String role;
  final String photoUrl;

  Person({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.role,
    required this.photoUrl
  });
}

// Base component
abstract class ProfileComponent {
  void displayProfile();
  Map<String, dynamic> toMap();
}

// Concrete component
class BasicProfile implements ProfileComponent {
  final Person person;
  BasicProfile(this.person);

  @override
  void displayProfile() {
    print('Name: ${person.name}\nEmail: ${person.email}\nPhone: ${person.phone}\nGender: ${person.gender}\nRole: ${person.role}');
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': person.name,
      'email': person.email,
      'phone': person.phone,
      'gender': person.gender,
      'role': person.role,
      'photoUrl': person.photoUrl,
    };
  }
}

// Decorator
abstract class ProfileDecorator implements ProfileComponent {
  final ProfileComponent component;
  ProfileDecorator(this.component);

  @override
  void displayProfile() => component.displayProfile();

  @override
  Map<String, dynamic> toMap() => component.toMap();
}

// Concrete decorator
class PatientProfileDecorator extends ProfileDecorator {
  final String bloodGroup;
  final String emergencyContact;
  final String medicalHistory;
  final String currentMedications;

  PatientProfileDecorator(
      super.component, {
        required this.bloodGroup,
        required this.emergencyContact,
        required this.medicalHistory,
        required this.currentMedications,
      });

  @override
  void displayProfile() {
    super.displayProfile();
    print('Blood Group: $bloodGroup\nEmergency Contact: $emergencyContact\nMedical History: $medicalHistory\nCurrent Medications: $currentMedications');
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'blood_group': bloodGroup,
      'emergency_contact': emergencyContact,
      'medical_history': medicalHistory,
      'current_medications': currentMedications,
    };
  }
}

// Concrete decorator
class DoctorProfileDecorator extends ProfileDecorator {
  final String specialization;
  final String licenceNumber;
  final String experienceLevel;
  final DateTime availableFrom;
  final DateTime availableUntil;
  final int consultationFee;

  DoctorProfileDecorator(
      super.component, {
        required this.specialization,
        required this.licenceNumber,
        required this.experienceLevel,
        required this.availableFrom,
        required this.availableUntil,
        required this.consultationFee,
      });

  @override
  void displayProfile() {
    super.displayProfile();
    print('Specialization: $specialization\nLicense: $licenceNumber\nExperience: $experienceLevel\nAvailability: $availableFrom\nFee: \$$consultationFee');
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'specialization': specialization,
      'licence_number': licenceNumber,
      'experience_level': experienceLevel,
      'availableFrom': availableFrom,
      'availableUntil': availableUntil,
      'consultation_fee': consultationFee,
      'verified': false,
    };
  }
}

// Concrete decorator
class StaffProfileDecorator extends ProfileDecorator {
  final String department;
  final String designation;
  final String shift;
  final int salary;

  StaffProfileDecorator(
      super.component, {
        required this.department,
        required this.designation,
        required this.shift,
        required this.salary,
      });

  @override
  void displayProfile() {
    super.displayProfile();
    print('Department: $department\nDesignation: $designation\nShift: $shift\nSalary: \$$salary');
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'department': department,
      'designation': designation,
      'shift': shift,
      'salary': salary,
      'verified': false,
    };
  }
}

// Concrete decorator
class AdminProfileDecorator extends ProfileDecorator {
  final String accessLevel;

  AdminProfileDecorator(super.component, {required this.accessLevel});

  @override
  void displayProfile() {
    super.displayProfile();
    print('Access Level: $accessLevel');
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'access_level': accessLevel,
      'verified': false,
    };
  }
}

// Repository - Main class
class UserRepository {
  Future<void> createNewUser(String userType) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final person = Person(
      id: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      phone: user.phoneNumber ?? '',
      gender: '',
      role: userType,
      photoUrl: user.photoURL ?? '',
    );

    ProfileComponent profile = BasicProfile(person);

    switch (userType) {
      case 'patient':
        profile = PatientProfileDecorator(profile,
            bloodGroup: '',
            emergencyContact: '',
            medicalHistory: '',
            currentMedications: '');
        break;
      case 'doctor':
        profile = DoctorProfileDecorator(profile,
            specialization: '',
            licenceNumber: '',
            experienceLevel: '',
            availableFrom: DateTime.now(),
            availableUntil: DateTime.now(),
            consultationFee: 0
        );
        break;
      case 'staff':
        profile = StaffProfileDecorator(profile,
            department: '',
            designation: '',
            shift: '',
            salary: 0);
        break;
      case 'admin':
        profile = AdminProfileDecorator(profile, accessLevel: '');
        break;
    }

    await FirebaseFirestore.instance.collection('user').doc(user.uid).set(profile.toMap());
  }

  static Future<void> updateUserProfile(String userId, ProfileControllers controllers) async {
    final person = Person(
      id: userId,
      name: controllers.name.text,
      email: controllers.email.text,
      phone: controllers.phoneNumber.text,
      gender: controllers.gender.text,
      role: controllers.role.text,
      photoUrl: FirebaseAuth.instance.currentUser?.photoURL ?? '',
    );

    ProfileComponent profile = BasicProfile(person);

    switch (controllers.role.text) {
      case 'patient':
        profile = PatientProfileDecorator(profile,
            bloodGroup: controllers.bloodGroup.text,
            emergencyContact: controllers.emergencyContact.text,
            medicalHistory: controllers.medicalHistory.text,
            currentMedications: controllers.currentMedications.text);
        break;
      case 'doctor':
        profile = DoctorProfileDecorator(profile,
            specialization: controllers.specialization.text,
            licenceNumber: controllers.licence.text,
            experienceLevel: controllers.experience.text,
            availableFrom: DateTime(
              controllers.selectedDate!.year,
              controllers.selectedDate!.month,
              controllers.selectedDate!.day,
              controllers.selectedFromTime!.hour,
              controllers.selectedFromTime!.minute,
            ),
            availableUntil: DateTime(
              controllers.selectedDate!.year,
              controllers.selectedDate!.month,
              controllers.selectedDate!.day,
              controllers.selectedUntilTime!.hour,
              controllers.selectedUntilTime!.minute,
            ),
            consultationFee: int.tryParse(controllers.fee.text) ?? 0);
        break;
      case 'staff':
        profile = StaffProfileDecorator(profile,
            department: controllers.department.text,
            designation: controllers.designation.text,
            shift: controllers.shift.text,
            salary: int.tryParse(controllers.salary.text) ?? 0);
        break;
      case 'admin':
        profile = AdminProfileDecorator(profile, accessLevel: controllers.access.text);
        break;
    }

    await FirebaseFirestore.instance.collection('user').doc(userId).update(profile.toMap());
  }

  Future<bool> checkUserExists(String userId) async {
    final snapshot = await FirebaseFirestore.instance.collection('user').doc(userId).get();
    return snapshot.exists;
  }
}