import 'appointment_observer_interface.dart';

class Appointment {
  final List<AppointmentObserverInterface> _observers = [];
  final String appointmentId;
  String _status = "Scheduled";

  Appointment(this.appointmentId);

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
    for(int i=0; i<_observers.length; i++){
      _observers[i].update(appointmentId, _status);
    }
  }
}