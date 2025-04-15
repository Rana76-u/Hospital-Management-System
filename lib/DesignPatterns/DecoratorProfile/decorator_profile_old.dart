//To Run code, type in terminal:
//dart run lib/DesignPatterns/DecoratorProfile/decorator_profile_old.dart

// Base models for the system
class Person {
  final String id;
  final String name;
  final String email;
  final String phone;

  Person({
    required this.id, 
    required this.name, 
    required this.email, 
    required this.phone
  });
}

class Employee extends Person {
  final DateTime dateOfJoining;
  final bool isPending; // Indicates if employee is pending approval

  Employee({
    required String id,
    required String name,
    required String email,
    required String phone,
    required this.dateOfJoining,
    this.isPending = true,
  }) : super(id: id, name: name, email: email, phone: phone);
}

class Doctor extends Employee {
  final String specialization;
  final String licenseNumber;
  final List<String> qualifications;

  Doctor({
    required String id,
    required String name,
    required String email,
    required String phone,
    required DateTime dateOfJoining,
    required this.specialization,
    required this.licenseNumber,
    required this.qualifications,
  }) : super(
          id: id,
          name: name,
          email: email,
          phone: phone,
          dateOfJoining: dateOfJoining,
          isPending: false,
        );
}

class Staff extends Employee {
  final String role;
  final String department;

  Staff({
    required String id,
    required String name,
    required String email,
    required String phone,
    required DateTime dateOfJoining,
    required this.role,
    required this.department,
  }) : super(
          id: id,
          name: name,
          email: email,
          phone: phone,
          dateOfJoining: dateOfJoining,
          isPending: false,
        );
}

class Patient extends Person {
  Patient({
    required String id,
    required String name,
    required String email,
    required String phone,
  }) : super(id: id, name: name, email: email, phone: phone);
}

// DECORATOR PATTERN IMPLEMENTATION

// 1. Component Interface
abstract class ProfileComponent {
  void displayProfile();
}

// 2. ConcreteComponent Class
class BasicProfile implements ProfileComponent {
  final Person person;

  BasicProfile(this.person);

  @override
  void displayProfile() {
    print('--------- BASIC PROFILE ---------');
    print('ID: ${person.id}');
    print('Name: ${person.name}');
    print('Email: ${person.email}');
    print('Phone: ${person.phone}');
  }
}

// 3. Decorator Abstract Class
abstract class ProfileDecorator implements ProfileComponent {
  final ProfileComponent wrappedProfile;

  ProfileDecorator(this.wrappedProfile);

  @override
  void displayProfile() {
    wrappedProfile.displayProfile();
  }
}

// 4. ConcreteDecorator Classes

// Employee Decorator
class EmployeeProfileDecorator extends ProfileDecorator {
  final Employee employee;

  EmployeeProfileDecorator(ProfileComponent wrappedProfile, this.employee)
      : super(wrappedProfile);

  @override
  void displayProfile() {
    super.displayProfile();
    print('\n--------- EMPLOYEE DETAILS ---------');
    print('Date of Joining: ${employee.dateOfJoining.toString().substring(0, 10)}');
    
    if (employee.isPending) {
      print('\n⚠️ PENDING APPROVAL: This employee is waiting for role assignment');
    }
  }
}

// Doctor Decorator
class DoctorProfileDecorator extends ProfileDecorator {
  final Doctor doctor;

  DoctorProfileDecorator(ProfileComponent wrappedProfile, this.doctor)
      : super(wrappedProfile);

  @override
  void displayProfile() {
    super.displayProfile();
    print('\n--------- DOCTOR DETAILS ---------');
    print('Specialization: ${doctor.specialization}');
    print('License Number: ${doctor.licenseNumber}');
    print('Qualifications:');
    for (var qualification in doctor.qualifications) {
      print('- $qualification');
    }
  }
}

// Staff Decorator
class StaffProfileDecorator extends ProfileDecorator {
  final Staff staff;

  StaffProfileDecorator(ProfileComponent wrappedProfile, this.staff)
      : super(wrappedProfile);

  @override
  void displayProfile() {
    super.displayProfile();
    print('\n--------- STAFF DETAILS ---------');
    print('Role: ${staff.role}');
    print('Department: ${staff.department}');
  }
}

// Patient Decorator
class PatientProfileDecorator extends ProfileDecorator {
  final Patient patient;

  PatientProfileDecorator(ProfileComponent wrappedProfile, this.patient)
      : super(wrappedProfile);

  @override
  void displayProfile() {
    super.displayProfile();
    print('\n--------- PATIENT DETAILS ---------');
    print('Type: Regular Patient');
    // Additional patient-specific information would go here
  }
}

// Factory for creating appropriate profile components
class ProfileFactory {
  static ProfileComponent createProfileFor(Person person) {
    // Start with basic profile
    ProfileComponent profile = BasicProfile(person);
    
    // Apply decorators based on person type
    if (person is Doctor) {
      profile = EmployeeProfileDecorator(profile, person);
      profile = DoctorProfileDecorator(profile, person);
    } else if (person is Staff) {
      profile = EmployeeProfileDecorator(profile, person);
      profile = StaffProfileDecorator(profile, person);
    } else if (person is Employee) {
      // This is a pending employee
      profile = EmployeeProfileDecorator(profile, person);
    } else if (person is Patient) {
      profile = PatientProfileDecorator(profile, person);
    }
    
    return profile;
  }
}

// Main function to test the implementation
void main() {
  // Create different types of users
  final patient = Patient(
    id: 'P001',
    name: 'John Doe',
    email: 'john.doe@example.com',
    phone: '123-456-7890',
  );
  
  final pendingEmployee = Employee(
    id: 'E001',
    name: 'Jane Smith',
    email: 'jane.smith@hospital.com',
    phone: '987-654-3210',
    dateOfJoining: DateTime.now(),
    isPending: true,
  );
  
  final doctor = Doctor(
    id: 'D001',
    name: 'Dr. Sarah Johnson',
    email: 'sarah.johnson@hospital.com',
    phone: '555-123-4567',
    dateOfJoining: DateTime(2020, 5, 15),
    specialization: 'Cardiology',
    licenseNumber: 'MED12345',
    qualifications: ['MD', 'PhD in Cardiology', 'Board Certified'],
  );
  
  final staff = Staff(
    id: 'S001',
    name: 'Mike Wilson',
    email: 'mike.wilson@hospital.com',
    phone: '555-987-6543',
    dateOfJoining: DateTime(2021, 3, 10),
    role: 'Nurse',
    department: 'Emergency',
  );
  
  // Display profiles
  print('\n========= PATIENT PROFILE =========');
  ProfileFactory.createProfileFor(patient).displayProfile();
  
  print('\n\n========= PENDING EMPLOYEE PROFILE =========');
  ProfileFactory.createProfileFor(pendingEmployee).displayProfile();
  
  print('\n\n========= DOCTOR PROFILE =========');
  ProfileFactory.createProfileFor(doctor).displayProfile();
  
  print('\n\n========= STAFF PROFILE =========');
  ProfileFactory.createProfileFor(staff).displayProfile();
}