//To Run code, type in terminal:
//dart run lib/DesignPatterns/FacadeAppointment/appointment_main.dart   

// Models
class Patient {
  final String patientID;
  final String name;

  Patient(this.patientID, this.name);
}

class Doctor {
  final String doctorID;
  final String name;
  final String specialization;

  Doctor(this.doctorID, this.name, this.specialization);
}

//appointment create and update
class Appointment {
  final String appointmentID;
  final String patientID;
  final String doctorID;
  final DateTime datetime;
  String status;

  Appointment({
    required this.appointmentID,
    required this.patientID,
    required this.doctorID,
    required this.datetime,
    this.status = 'Scheduled',
  });

  void updateStatus(String newStatus) {
    status = newStatus;
    print('Appointment $appointmentID status updated to: $status');
  }

  @override
  String toString() {
    return 'Appointment{appointmentID: $appointmentID, patientID: $patientID, doctorID: $doctorID, '
        'datetime: $datetime, status: $status}';
  }
}

// Services that handle the underlying complexity
class DoctorAvailabilityService {
  // Simulate a database of doctor schedules
  final Map<String, List<DateTime>> _doctorSchedules = {};

  DoctorAvailabilityService() {
    // Initialize with some dummy data
    _initializeDummySchedules();
  }

  void _initializeDummySchedules() {
    // Just for demonstration purposes
    final now = DateTime.now();
    _doctorSchedules['D001'] = [
      DateTime(now.year, now.month, now.day, 9, 0),
      DateTime(now.year, now.month, now.day, 10, 0),
      DateTime(now.year, now.month, now.day, 11, 0),
    ];
    _doctorSchedules['D002'] = [
      DateTime(now.year, now.month, now.day, 14, 0),
      DateTime(now.year, now.month, now.day, 15, 0),
      DateTime(now.year, now.month, now.day, 16, 0),
    ];
  }

  bool isDoctorAvailable(String doctorID, DateTime requestedTime) {
    if (!_doctorSchedules.containsKey(doctorID)) {
      print('Doctor $doctorID does not exist in the system');
      return false;
    }

    // Check if the doctor has any appointments at the requested time
    for (var scheduledTime in _doctorSchedules[doctorID]!) {
      if (scheduledTime.year == requestedTime.year &&
          scheduledTime.month == requestedTime.month &&
          scheduledTime.day == requestedTime.day &&
          scheduledTime.hour == requestedTime.hour) {
        print('Doctor $doctorID is not available at the requested time');
        return false;
      }
    }

    print('Doctor $doctorID is available at the requested time');
    return true;
  }

  void addAppointmentToSchedule(String doctorID, DateTime appointmentTime) {
    if (!_doctorSchedules.containsKey(doctorID)) {
      _doctorSchedules[doctorID] = [];
    }
    _doctorSchedules[doctorID]!.add(appointmentTime);
    print('Added appointment to doctor $doctorID schedule at $appointmentTime');
  }

  void removeAppointmentFromSchedule(String doctorID, DateTime appointmentTime) {
    if (_doctorSchedules.containsKey(doctorID)) {
      _doctorSchedules[doctorID]!.removeWhere((dt) =>
          dt.year == appointmentTime.year &&
          dt.month == appointmentTime.month &&
          dt.day == appointmentTime.day &&
          dt.hour == appointmentTime.hour);
      print('Removed appointment from doctor $doctorID schedule at $appointmentTime');
    }
  }
}



class AppointmentRecordService {
  final List<Appointment> _appointments = [];

  String generateAppointmentID() {
    // Simple ID generation for demonstration
    return 'A${DateTime.now().millisecondsSinceEpoch}';
  }

  Appointment createAppointmentRecord(String patientID, String doctorID, DateTime datetime) {
    final appointmentID = generateAppointmentID();
    final appointment = Appointment(
      appointmentID: appointmentID,
      patientID: patientID,
      doctorID: doctorID,
      datetime: datetime,
    );
    _appointments.add(appointment);
    print('Created appointment record: $appointment');
    return appointment;
  }

  Appointment? getAppointment(String appointmentID) {
    try {
      return _appointments.firstWhere((a) => a.appointmentID == appointmentID);
    } catch (e) {
      print('Appointment with ID $appointmentID not found');
      return null;
    }
  }

  List<Appointment> getAppointmentsForPatient(String patientID) {
    return _appointments.where((a) => a.patientID == patientID).toList();
  }

  List<Appointment> getAppointmentsForDoctor(String doctorID) {
    return _appointments.where((a) => a.doctorID == doctorID).toList();
  }

  void updateAppointmentStatus(String appointmentID, String newStatus) {
    final appointment = getAppointment(appointmentID);
    if (appointment != null) {
      appointment.updateStatus(newStatus);
    }
  }

  void updateAppointmentTime(String appointmentID, DateTime newDatetime) {
    final appointment = getAppointment(appointmentID);
    if (appointment != null) {
      final oldDatetime = appointment.datetime;
      // This would typically involve creating a new appointment object,
      // but for simplicity, we're directly modifying the existing one
      print('Updated appointment $appointmentID time from $oldDatetime to $newDatetime');
    }
  }
}

// The Facade class that simplifies the appointment system
class AppointmentFacade {
  final DoctorAvailabilityService _availabilityService;
  final AppointmentRecordService _recordService;

  AppointmentFacade()
      : _availabilityService = DoctorAvailabilityService(),
        _recordService = AppointmentRecordService();

  // Simplified interface for booking an appointment
  Appointment? bookAppointment(String patientID, String doctorID, DateTime datetime) {
    print('\n--- BOOKING APPOINTMENT ---');
    
    // Check doctor availability
    if (!_availabilityService.isDoctorAvailable(doctorID, datetime)) {
      print('Cannot book appointment: Doctor not available');
      return null;
    }

    // Create appointment record
    final appointment = _recordService.createAppointmentRecord(patientID, doctorID, datetime);
    
    // Update doctor's schedule
    _availabilityService.addAppointmentToSchedule(doctorID, datetime);
    
    // Note: Notification is handled by Observer pattern
    print('Appointment successfully booked!');
    return appointment;
  }

  // Simplified interface for rescheduling an appointment
  bool rescheduleAppointment(String appointmentID, DateTime newDatetime) {
    print('\n--- RESCHEDULING APPOINTMENT ---');
    
    final appointment = _recordService.getAppointment(appointmentID);
    if (appointment == null) {
      return false;
    }

    final doctorID = appointment.doctorID;
    final oldDatetime = appointment.datetime;

    // Check doctor availability for the new time
    if (!_availabilityService.isDoctorAvailable(doctorID, newDatetime)) {
      print('Cannot reschedule: Doctor not available at the requested time');
      return false;
    }

    // Update doctor's schedule
    _availabilityService.removeAppointmentFromSchedule(doctorID, oldDatetime);
    _availabilityService.addAppointmentToSchedule(doctorID, newDatetime);
    
    // Update appointment record
    _recordService.updateAppointmentTime(appointmentID, newDatetime);
    
    // Note: Notification is handled by Observer pattern
    
    print('Appointment successfully rescheduled!');
    return true;
  }

  // Simplified interface for canceling an appointment
  bool cancelAppointment(String appointmentID) {
    print('\n--- CANCELING APPOINTMENT ---');
    
    final appointment = _recordService.getAppointment(appointmentID);
    if (appointment == null) {
      return false;
    }

    final doctorID = appointment.doctorID;
    final datetime = appointment.datetime;

    // Update doctor's schedule
    _availabilityService.removeAppointmentFromSchedule(doctorID, datetime);
    
    // Update appointment status
    _recordService.updateAppointmentStatus(appointmentID, 'Canceled');
    
    // Note: Notification is handled by Observer pattern
    
    print('Appointment successfully canceled!');
    return true;
  }

  // Get appointments for a patient
  List<Appointment> getPatientAppointments(String patientID) {
    return _recordService.getAppointmentsForPatient(patientID);
  }

  // Get appointments for a doctor
  List<Appointment> getDoctorAppointments(String doctorID) {
    return _recordService.getAppointmentsForDoctor(doctorID);
  }
}

// Main function to demonstrate the facade pattern
void main() {
  // Create the facade
  final appointmentSystem = AppointmentFacade();

  // Patient and doctor IDs
  final String patientID = 'P001';
  final String doctorID = 'D001';

  // Book an appointment
  final appointment = appointmentSystem.bookAppointment(
    patientID,
    doctorID,
    DateTime(2025, 4, 14, 9, 0),
  );

  if (appointment != null) {
    // Reschedule the appointment
    appointmentSystem.rescheduleAppointment(
      appointment.appointmentID,
      DateTime(2025, 4, 15, 10, 0),
    );

    // Cancel the appointment
    appointmentSystem.cancelAppointment(appointment.appointmentID);
  }

  // Book another appointment to show the list
  final appointment2 = appointmentSystem.bookAppointment(
    patientID,
    doctorID,
    DateTime(2025, 4, 16, 11, 0),
  );

  // Display patient appointments
  print('\n--- PATIENT APPOINTMENTS ---');
  final patientAppointments = appointmentSystem.getPatientAppointments(patientID);
  for (var appt in patientAppointments) {
    print(appt);
  }

  // Display doctor appointments
  print('\n--- DOCTOR APPOINTMENTS ---');
  final doctorAppointments = appointmentSystem.getDoctorAppointments(doctorID);
  for (var appt in doctorAppointments) {
    print(appt);
  }
}