import 'appointment_observer_interface.dart';

class Doctor implements AppointmentObserverInterface {
  final String name;

  Doctor(this.name);

  @override
  void update(String appointmentId, String status) {
    print("Doctor $name notified: Appointment $appointmentId is now $status");
  }
}

class Patient implements AppointmentObserverInterface {
  final String name;

  Patient(this.name);

  @override
  void update(String appointmentId, String status) {
    print("Patient $name notified: Appointment $appointmentId is now $status");
  }
}

class Receptionist implements AppointmentObserverInterface {
  @override
  void update(String appointmentId, String status) {
    print("Receptionist notified: Appointment $appointmentId is now $status");
  }
}