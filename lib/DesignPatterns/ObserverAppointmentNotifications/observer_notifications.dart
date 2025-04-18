// Used in AppointmentFacade().bookAppointment()
import 'package:cloud_firestore/cloud_firestore.dart';

//interface
abstract class AppointmentObserverInterface {
  String get userId;
  String get role; // 'doctor' or 'patient'
  void update(String appointmentId, String status);
}

//Subject
class AppointmentNotification {
  final List<AppointmentObserverInterface> _observers = [];
  final String appointmentId;
  String _status = "Scheduled";

  AppointmentNotification(this.appointmentId);

  void addObserver(AppointmentObserverInterface observer) {
    _observers.add(observer);
  }

  void removeObserver(AppointmentObserverInterface observer) {
    _observers.remove(observer);
  }

  void setStatus(String status) {
    _status = status;
    _notifyObservers();
  }

  String get status {
    return _status;
  }

  void _notifyObservers() {
    for (var observer in _observers) {
      // Add notification entry to Firestore for each observer
      FirebaseFirestore.instance.collection('notifications').add({
        'appointmentId': appointmentId,
        'status': _status,
        'timestamp': DateTime.now(),
        'userId': observer.userId,
        'role': observer.role,
        'message': 'Appointment $appointmentId is now $_status',
        'read': false,
      });

      // Also call the update function
      observer.update(appointmentId, _status);
    }
  }

  void clearObservers() {
    _observers.clear();
  }
}

//Concrete Observer
class ObserverDoctor implements AppointmentObserverInterface {
  final String _id;
  ObserverDoctor(this._id);

  @override
  String get userId => _id;

  @override
  String get role => 'doctor';

  @override
  void update(String appointmentId, String status) {
    print("👨‍⚕️ Doctor $userId notified: Appointment $appointmentId is $status");
  }
}

//Concrete Observer
class ObserverPatient implements AppointmentObserverInterface {
  final String _id;
  ObserverPatient(this._id);

  @override
  String get userId => _id;

  @override
  String get role => 'patient';

  @override
  void update(String appointmentId, String status) {
    print("🧑‍⚕️ Patient $userId notified: Appointment $appointmentId is $status");
  }
}
