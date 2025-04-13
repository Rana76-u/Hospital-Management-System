import 'appointment_subject.dart';
import 'concrete_observers.dart';

class AppointmentMain {
  void createAnAppointment(String appointmentId, String doctorId, String patientId, String status) {
    // Create an appointment
    Appointment appointment = Appointment(appointmentId); //"APT-101"

    // Create observers
    Doctor doctor = Doctor(doctorId); //"Dr. Smith"
    Patient patient = Patient(patientId); // "John Doe"
    Receptionist receptionist = Receptionist();

    // Register observers
    appointment.addObserver(doctor);
    appointment.addObserver(patient);
    appointment.addObserver(receptionist);

    // Update appointment status
    print("\n🔔 Updating Appointment Status to CONFIRMED...");
    appointment.setStatus(status); // "CONFIRMED"
  }
}