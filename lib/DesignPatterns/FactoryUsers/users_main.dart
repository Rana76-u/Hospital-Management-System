//To Run code, type in terminal:
//dart run lib/DesignPatterns/FactoryUsers/user_main.dart


// Abstract Product - User (base class)
abstract class User {
  String? id;
  String? name;
  String? email;
  String? password;
  
  void displayInfo();
}

// Concrete Products - Different User Types
class Admin extends User {
  String? adminLevel;
  List<String>? permissions;
  
  Admin({String? id, String? name, String? email, String? password, this.adminLevel, this.permissions}) {
    this.id = id;
    this.name = name;
    this.email = email;
    this.password = password;
  }
  
  @override
  void displayInfo() {
    print('===== ADMIN USER =====');
    print('ID: $id');
    print('Name: $name');
    print('Email: $email');
    print('Admin Level: $adminLevel');
    print('Permissions: ${permissions?.join(", ") ?? "None"}');
    print('=====================');
  }
}

class Doctor extends User {
  String? specialization;
  String? licenseNumber;
  
  Doctor({String? id, String? name, String? email, String? password, this.specialization, this.licenseNumber}) {
    this.id = id;
    this.name = name;
    this.email = email;
    this.password = password;
  }
  
  @override
  void displayInfo() {
    print('===== DOCTOR USER =====');
    print('ID: $id');
    print('Name: $name');
    print('Email: $email');
    print('Specialization: $specialization');
    print('License Number: $licenseNumber');
    print('======================');
  }
}

class Staff extends User {
  String? department;
  String? role;
  
  Staff({String? id, String? name, String? email, String? password, this.department, this.role}) {
    this.id = id;
    this.name = name;
    this.email = email;
    this.password = password;
  }
  
  @override
  void displayInfo() {
    print('===== STAFF USER =====');
    print('ID: $id');
    print('Name: $name');
    print('Email: $email');
    print('Department: $department');
    print('Role: $role');
    print('=====================');
  }
}

class Patient extends User {
  String? medicalRecordNumber;
  String? dateOfBirth;
  String? bloodType;
  
  Patient({String? id, String? name, String? email, String? password, this.medicalRecordNumber, 
          this.dateOfBirth, this.bloodType}) {
    this.id = id;
    this.name = name;
    this.email = email;
    this.password = password;
  }
  
  @override
  void displayInfo() {
    print('===== PATIENT USER =====');
    print('ID: $id');
    print('Name: $name');
    print('Email: $email');
    print('Medical Record Number: $medicalRecordNumber');
    print('Date of Birth: $dateOfBirth');
    print('Blood Type: $bloodType');
    print('=======================');
  }
}

// Abstract Creator
abstract class UserCreator {
  User createUser();
}

// Concrete Creators
class AdminCreator extends UserCreator {
  final String? id;
  final String? name;
  final String? email;
  final String? password;
  final String? adminLevel;
  final List<String>? permissions;
  
  AdminCreator({this.id, this.name, this.email, this.password, this.adminLevel, this.permissions});
  
  @override
  User createUser() {
    return Admin(
      id: id,
      name: name,
      email: email,
      password: password,
      adminLevel: adminLevel,
      permissions: permissions
    );
  }
}

class DoctorCreator extends UserCreator {
  final String? id;
  final String? name;
  final String? email;
  final String? password;
  final String? specialization;
  final String? licenseNumber;
  
  DoctorCreator({this.id, this.name, this.email, this.password, this.specialization, this.licenseNumber});
  
  @override
  User createUser() {
    return Doctor(
      id: id,
      name: name,
      email: email,
      password: password,
      specialization: specialization,
      licenseNumber: licenseNumber
    );
  }
}

class StaffCreator extends UserCreator {
  final String? id;
  final String? name;
  final String? email;
  final String? password;
  final String? department;
  final String? role;
  
  StaffCreator({this.id, this.name, this.email, this.password, this.department, this.role});
  
  @override
  User createUser() {
    return Staff(
      id: id,
      name: name,
      email: email,
      password: password,
      department: department,
      role: role
    );
  }
}

class PatientCreator extends UserCreator {
  final String? id;
  final String? name;
  final String? email;
  final String? password;
  final String? medicalRecordNumber;
  final String? dateOfBirth;
  final String? bloodType;
  
  PatientCreator({this.id, this.name, this.email, this.password, this.medicalRecordNumber, 
                 this.dateOfBirth, this.bloodType});
  
  @override
  User createUser() {
    return Patient(
      id: id,
      name: name,
      email: email,
      password: password,
      medicalRecordNumber: medicalRecordNumber,
      dateOfBirth: dateOfBirth,
      bloodType: bloodType
    );
  }
}

// User Factory - Simplifies user creation
class UserFactory {
  static User createAdmin({String? id, String? name, String? email, String? password, 
                          String? adminLevel, List<String>? permissions}) {
    return AdminCreator(
      id: id,
      name: name,
      email: email,
      password: password,
      adminLevel: adminLevel,
      permissions: permissions
    ).createUser();
  }
  
  static User createDoctor({String? id, String? name, String? email, String? password, 
                           String? specialization, String? licenseNumber}) {
    return DoctorCreator(
      id: id,
      name: name,
      email: email,
      password: password,
      specialization: specialization,
      licenseNumber: licenseNumber
    ).createUser();
  }
  
  static User createStaff({String? id, String? name, String? email, String? password, 
                          String? department, String? role}) {
    return StaffCreator(
      id: id,
      name: name,
      email: email,
      password: password,
      department: department,
      role: role
    ).createUser();
  }
  
  static User createPatient({String? id, String? name, String? email, String? password, 
                            String? medicalRecordNumber, String? dateOfBirth, String? bloodType}) {
    return PatientCreator(
      id: id,
      name: name,
      email: email,
      password: password,
      medicalRecordNumber: medicalRecordNumber,
      dateOfBirth: dateOfBirth,
      bloodType: bloodType
    ).createUser();
  }
}

// Example usage in main.dart
void main() {
  // Direct creation using specific factory methods
  User admin = UserFactory.createAdmin(
    id: 'A001',
    name: 'John Admin',
    email: 'john.admin@hospital.com',
    password: 'securepass123',
    adminLevel: 'Super Admin',
    permissions: ['all', 'manage_staff', 'manage_doctors', 'manage_system']
  );
  
  User doctor = UserFactory.createDoctor(
    id: 'D001',
    name: 'Dr. Sarah Smith',
    email: 'sarah.smith@hospital.com',
    password: 'dr123secure',
    specialization: 'Cardiology',
    licenseNumber: 'MED-5839-CA'
  );
  
  User staff = UserFactory.createStaff(
    id: 'S001',
    name: 'Mike Johnson',
    email: 'mike.johnson@hospital.com',
    password: 'staffpass456',
    department: 'Radiology',
    role: 'Technician'
  );
  
  User patient = UserFactory.createPatient(
    id: 'P001',
    name: 'Emily Parker',
    email: 'emily.parker@gmail.com',
    password: 'patient789',
    medicalRecordNumber: 'MRN-7834-21',
    dateOfBirth: '1990-05-15',
    bloodType: 'O+'
  );
  
  // Using generic creation method with map data
  User admin2 = UserFactory.createAdmin(
    id: 'A002',
    name: 'Jane Admin',
    email: 'jane.admin@hospital.com',
    password: 'securepass456',
    adminLevel: 'Department Admin',
    permissions: ['manage_department', 'view_reports']
  );
  
  // Display all users' information
  admin.displayInfo();
  doctor.displayInfo();
  staff.displayInfo();
  patient.displayInfo();
  admin2.displayInfo();
}