//To Run code, type in terminal:
//dart run lib/DesignPatterns/FactoryEmployee/employee_main.dart

// Employee Management using Factory Pattern in Dart
// This implementation demonstrates how an admin can create and manage 
// different types of employees (doctors and staff) with their specializations.

// ----- PRODUCTS -----

// Abstract Product: Employee
abstract class Employee {
  String id;
  String name;
  String email;
  String phone;
  DateTime dateOfJoining;
  
  Employee(this.id, this.name, this.email, this.phone, this.dateOfJoining);
  
  void displayInfo();
}

// Concrete Product 1: Doctor
class Doctor extends Employee {
  String specialization;
  String licenseNumber;
  List<String> qualifications;
  
  Doctor(
    String id, 
    String name, 
    String email, 
    String phone, 
    DateTime dateOfJoining,
    this.specialization,
    this.licenseNumber,
    this.qualifications
  ) : super(id, name, email, phone, dateOfJoining);
  
  @override
  void displayInfo() {
    print('\n--- DOCTOR INFORMATION ---');
    print('ID: $id');
    print('Name: $name');
    print('Email: $email');
    print('Phone: $phone');
    print('Date of Joining: ${dateOfJoining.toString().split(' ')[0]}');
    print('Specialization: $specialization');
    print('License Number: $licenseNumber');
    print('Qualifications: ${qualifications.join(", ")}');
  }
}

// Concrete Product 2: Staff
class Staff extends Employee {
  String role;
  String department;
  
  Staff(
    String id, 
    String name, 
    String email, 
    String phone, 
    DateTime dateOfJoining,
    this.role,
    this.department
  ) : super(id, name, email, phone, dateOfJoining);
  
  @override
  void displayInfo() {
    print('\n--- STAFF INFORMATION ---');
    print('ID: $id');
    print('Name: $name');
    print('Email: $email');
    print('Phone: $phone');
    print('Date of Joining: ${dateOfJoining.toString().split(' ')[0]}');
    print('Role: $role');
    print('Department: $department');
  }
}

// ----- DATA CLASSES -----

// Base employee data class
class EmployeeData {
  final String id;
  final String name;
  final String email;
  final String phone;
  final DateTime dateOfJoining;
  
  EmployeeData({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.dateOfJoining,
  });
  
  // Validate common employee data
  List<String> validate() {
    List<String> errors = [];
    
    if (id.isEmpty) errors.add("Employee ID cannot be empty");
    if (name.isEmpty) errors.add("Name cannot be empty");
    if (!email.contains('@')) errors.add("Invalid email format");
    if (phone.isEmpty) errors.add("Phone number cannot be empty");
    if (dateOfJoining.isAfter(DateTime.now())) errors.add("Date of joining cannot be in future");
    
    return errors;
  }
}

// Doctor-specific data class
class DoctorData extends EmployeeData {
  final String specialization;
  final String licenseNumber;
  final List<String> qualifications;
  
  DoctorData({
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
    );
  
  // Validate doctor-specific data
  @override
  List<String> validate() {
    List<String> errors = super.validate();
    
    if (specialization.isEmpty) errors.add("Specialization cannot be empty");
    if (licenseNumber.isEmpty) errors.add("License number cannot be empty");
    if (qualifications.isEmpty) errors.add("At least one qualification is required");
    
    return errors;
  }
}

// Staff-specific data class
class StaffData extends EmployeeData {
  final String role;
  final String department;
  
  StaffData({
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
    );
  
  // Validate staff-specific data
  @override
  List<String> validate() {
    List<String> errors = super.validate();
    
    if (role.isEmpty) errors.add("Role cannot be empty");
    if (department.isEmpty) errors.add("Department cannot be empty");
    
    return errors;
  }
}

// ----- CREATORS -----

// Abstract Creator: EmployeeFactory
abstract class EmployeeFactory<T extends EmployeeData> {
  // Factory method with typed data parameter
  Employee? createEmployee(T employeeData);
}

// Concrete Creator 1: DoctorFactory
class DoctorFactory extends EmployeeFactory<DoctorData> {
  @override
  Employee? createEmployee(DoctorData data) {
    // Validate data
    final errors = data.validate();
    if (errors.isNotEmpty) {
      print("Cannot create doctor due to following errors:");
      for (var error in errors) {
        print("- $error");
      }
      return null;
    }
    
    return Doctor(
      data.id,
      data.name,
      data.email,
      data.phone,
      data.dateOfJoining,
      data.specialization,
      data.licenseNumber,
      data.qualifications,
    );
  }
}

// Concrete Creator 2: StaffFactory
class StaffFactory extends EmployeeFactory<StaffData> {
  @override
  Employee? createEmployee(StaffData data) {
    // Validate data
    final errors = data.validate();
    if (errors.isNotEmpty) {
      print("Cannot create staff member due to following errors:");
      for (var error in errors) {
        print("- $error");
      }
      return null;
    }
    
    return Staff(
      data.id,
      data.name,
      data.email,
      data.phone,
      data.dateOfJoining,
      data.role,
      data.department,
    );
  }
}

// ----- ADMIN -----

// Exception for employee creation failures
class EmployeeCreationException implements Exception {
  final String message;
  EmployeeCreationException(this.message);
  
  @override
  String toString() => 'EmployeeCreationException: $message';
}

// Admin class that will use the factories to create employees
class Admin {
  final DoctorFactory _doctorFactory = DoctorFactory();
  final StaffFactory _staffFactory = StaffFactory();
  
  List<Employee> employees = [];
  
  // Check if employee ID already exists
  bool _isIdUnique(String id) {
    return !employees.any((employee) => employee.id == id);
  }
  
  // Create a doctor
  Employee createDoctor({
    required String id,
    required String name,
    required String email,
    required String phone,
    required DateTime dateOfJoining,
    required String specialization,
    required String licenseNumber,
    required List<String> qualifications,
  }) {
    // Check for duplicate ID
    if (!_isIdUnique(id)) {
      throw EmployeeCreationException('Employee with ID $id already exists');
    }
    
    // Create doctor data object
    final doctorData = DoctorData(
      id: id,
      name: name,
      email: email,
      phone: phone,
      dateOfJoining: dateOfJoining,
      specialization: specialization,
      licenseNumber: licenseNumber,
      qualifications: qualifications,
    );
    
    // Create doctor using factory
    final doctor = _doctorFactory.createEmployee(doctorData);
    
    if (doctor == null) {
      throw EmployeeCreationException('Failed to create doctor with the provided data');
    }
    
    employees.add(doctor);
    print('Doctor created successfully.');
    return doctor;
  }
  
  // Create a staff member
  Employee createStaff({
    required String id,
    required String name,
    required String email,
    required String phone,
    required DateTime dateOfJoining,
    required String role,
    required String department,
  }) {
    // Check for duplicate ID
    if (!_isIdUnique(id)) {
      throw EmployeeCreationException('Employee with ID $id already exists');
    }
    
    // Create staff data object
    final staffData = StaffData(
      id: id,
      name: name,
      email: email,
      phone: phone,
      dateOfJoining: dateOfJoining,
      role: role,
      department: department,
    );
    
    // Create staff using factory
    final staff = _staffFactory.createEmployee(staffData);
    
    if (staff == null) {
      throw EmployeeCreationException('Failed to create staff member with the provided data');
    }
    
    employees.add(staff);
    print('Staff created successfully.');
    return staff;
  }
  
  // Display all employees
  void displayAllEmployees() {
    if (employees.isEmpty) {
      print('\nNo employees found.');
      return;
    }
    
    print('\n===== ALL EMPLOYEES =====');
    for (var employee in employees) {
      employee.displayInfo();
    }
  }
  
  // Get employee by ID
  Employee? getEmployeeById(String id) {
    for (var employee in employees) {
      if (employee.id == id) {
        return employee;
      }
    }
    return null;
  }
  
  // Count employees by type
  Map<String, int> getEmployeeCountByType() {
    int doctorCount = 0;
    int staffCount = 0;
    
    for (var employee in employees) {
      if (employee is Doctor) {
        doctorCount++;
      } else if (employee is Staff) {
        staffCount++;
      }
    }
    
    return {
      'doctors': doctorCount,
      'staff': staffCount,
      'total': employees.length,
    };
  }
}

// ----- MAIN FUNCTION -----

void main() {
  // Create admin instance
  final admin = Admin();
  
  // Success and error handling examples
  print('\n===== EMPLOYEE CREATION EXAMPLES =====');
  
  try {
    // Create some doctors with different specializations
    admin.createDoctor(
      id: 'DOC001',
      name: 'Dr. John Smith',
      email: 'john.smith@hospital.com',
      phone: '+1-234-567-8901',
      dateOfJoining: DateTime(2020, 5, 15),
      specialization: 'Cardiology',
      licenseNumber: 'MED123456',
      qualifications: ['MBBS', 'MD Cardiology', 'FRCS'],
    );
    
    admin.createDoctor(
      id: 'DOC002',
      name: 'Dr. Sarah Johnson',
      email: 'sarah.johnson@hospital.com',
      phone: '+1-234-567-8902',
      dateOfJoining: DateTime(2019, 8, 10),
      specialization: 'Pediatrics',
      licenseNumber: 'MED234567',
      qualifications: ['MBBS', 'MD Pediatrics'],
    );
    
    // Example of error case - duplicate ID
    print("\nTrying to create a doctor with a duplicate ID:");
    admin.createDoctor(
      id: 'DOC001', // Duplicate ID
      name: 'Dr. Jane Doe',
      email: 'jane.doe@hospital.com',
      phone: '+1-234-567-8906',
      dateOfJoining: DateTime(2023, 2, 20),
      specialization: 'Neurology',
      licenseNumber: 'MED345678',
      qualifications: ['MBBS', 'MD Neurology'],
    );
  } catch (e) {
    print("Error: $e");
  }
  
  try {
    // Create some staff with different roles
    admin.createStaff(
      id: 'STF001',
      name: 'Michael Brown',
      email: 'michael.brown@hospital.com',
      phone: '+1-234-567-8903',
      dateOfJoining: DateTime(2021, 3, 22),
      role: 'Nurse',
      department: 'Emergency',
    );
    
    admin.createStaff(
      id: 'STF002',
      name: 'Emily Davis',
      email: 'emily.davis@hospital.com',
      phone: '+1-234-567-8904',
      dateOfJoining: DateTime(2022, 1, 5),
      role: 'Receptionist',
      department: 'Front Desk',
    );
    
    admin.createStaff(
      id: 'STF003',
      name: 'Robert Wilson',
      email: 'robert.wilson@hospital.com',
      phone: '+1-234-567-8905',
      dateOfJoining: DateTime(2021, 7, 15),
      role: 'Lab Technician',
      department: 'Pathology',
    );
    
    // Example of validation error - invalid email
    print("\nTrying to create a staff member with invalid email:");
    admin.createStaff(
      id: 'STF004',
      name: 'Jennifer Lopez',
      email: 'jennifer.lopezathospital.com', // Invalid email (missing @)
      phone: '+1-234-567-8907',
      dateOfJoining: DateTime(2023, 5, 10),
      role: 'Pharmacist',
      department: 'Pharmacy',
    );
  } catch (e) {
    print("Error: $e");
  }
  
  // Display all employees
  admin.displayAllEmployees();
  
  // Get and display employee counts
  final counts = admin.getEmployeeCountByType();
  print('\n===== EMPLOYEE COUNTS =====');
  print('Doctors: ${counts['doctors']}');
  print('Staff: ${counts['staff']}');
  print('Total Employees: ${counts['total']}');
  
  // Get an employee by ID - successful lookup
  print('\n===== EMPLOYEE LOOKUP (SUCCESS) =====');
  final employeeId = 'DOC001';
  final employee = admin.getEmployeeById(employeeId);
  
  if (employee != null) {
    print('Found employee with ID $employeeId:');
    employee.displayInfo();
  } else {
    print('No employee found with ID $employeeId');
  }
  
  // Get an employee by ID - unsuccessful lookup
  print('\n===== EMPLOYEE LOOKUP (NOT FOUND) =====');
  final nonExistentId = 'DOC999';
  final notFoundEmployee = admin.getEmployeeById(nonExistentId);
  
  if (notFoundEmployee != null) {
    print('Found employee with ID $nonExistentId:');
    notFoundEmployee.displayInfo();
  } else {
    print('No employee found with ID $nonExistentId');
  }
}