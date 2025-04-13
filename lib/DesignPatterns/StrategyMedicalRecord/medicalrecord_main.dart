//To Run code, type in terminal:
//dart run lib/DesignPatterns/StrategyMedicalRecord/medicalrecord_main.dart 


// Medical Record model
class MedicalRecord {
  String id;
  String patientID;
  String doctorID;
  String details;
  DateTime datetime;

  MedicalRecord({
    required this.id,
    required this.patientID,
    required this.doctorID,
    required this.details,
    required this.datetime,
  });

  @override
  String toString() {
    return 'MedicalRecord(id: $id, patientID: $patientID, doctorID: $doctorID, details: $details, datetime: ${datetime.toString()})';
  }
}

// Strategy interface
abstract class MedicalRecordStrategy {
  void processMedicalRecord(MedicalRecord record, String editorID, String newDetails);
}

// Concrete strategies
class ViewMedicalRecordStrategy implements MedicalRecordStrategy {
  @override
  void processMedicalRecord(MedicalRecord record, String editorID, String newDetails) {
    print('User $editorID is viewing medical record for patient ${record.patientID}');
    print('Record details: ${record.details}');
  }
}

class AddMedicalRecordStrategy implements MedicalRecordStrategy {
  @override
  void processMedicalRecord(MedicalRecord record, String editorID, String newDetails) {
    if (record.details.isEmpty) {
      record.details = newDetails;
      record.datetime = DateTime.now();
      if (editorID == record.patientID) {
        print('Patient ${record.patientID} added their medical history');
      } else if (editorID == record.doctorID) {
        print('Doctor ${record.doctorID} added medical history for patient ${record.patientID}');
      }
    } else {
      print('Medical record already exists. Use update strategy instead.');
    }
  }
}

class UpdateMedicalRecordStrategy implements MedicalRecordStrategy {
  @override
  void processMedicalRecord(MedicalRecord record, String editorID, String newDetails) {
    if (record.details.isNotEmpty) {
      String oldDetails = record.details;
      record.details = newDetails;
      record.datetime = DateTime.now();
      
      if (editorID == record.patientID) {
        print('Patient ${record.patientID} updated their medical history');
      } else if (editorID == record.doctorID) {
        print('Doctor ${record.doctorID} updated medical history for patient ${record.patientID}');
      }
      print('Previous details: $oldDetails');
      print('Updated details: ${record.details}');
    } else {
      print('Medical record does not exist. Use add strategy instead.');
    }
  }
}

// Context class that will use the strategies
class MedicalRecordManager {
  MedicalRecordStrategy? _strategy;

  void setStrategy(MedicalRecordStrategy strategy) {
    _strategy = strategy;
  }

  void processMedicalRecord(MedicalRecord record, String editorID, String newDetails) {
    if (_strategy == null) {
      print('Error: No strategy set');
      return;
    }
    
    // Validate access rights
    if (editorID != record.patientID && editorID != record.doctorID) {
      print('Access denied: User $editorID is not authorized to modify this record');
      return;
    }
    
    _strategy!.processMedicalRecord(record, editorID, newDetails);
  }
}

// Medical Record Repository to manage records
class MedicalRecordRepository {
  final Map<String, MedicalRecord> _records = {};

  MedicalRecord? getRecordByPatientID(String patientID) {
    return _records.values.firstWhere(
      (record) => record.patientID == patientID,
      orElse: () => MedicalRecord(
        id: 'new_${DateTime.now().millisecondsSinceEpoch}',
        patientID: patientID,
        doctorID: '',
        details: '',
        datetime: DateTime.now(),
      ),
    );
  }

  void saveRecord(MedicalRecord record) {
    _records[record.id] = record;
    print('Record saved: ${record.id}');
  }
}

// Main function to demonstrate the implementation
void main() {
  // Create repository
  final repository = MedicalRecordRepository();
  
  // Create context
  final manager = MedicalRecordManager();
  
  // Create users
  final patientID = 'P001';
  final doctorID = 'D001';
  
  // Scenario 1: Patient adds their own medical history
  print('\n--- Scenario 1: Patient adds their own medical history ---');
  var record = repository.getRecordByPatientID(patientID);
  record!.doctorID = doctorID; // Assign a doctor
  
  manager.setStrategy(AddMedicalRecordStrategy());
  manager.processMedicalRecord(
    record,
    patientID,
    'I have a history of asthma and allergies to peanuts.'
  );
  repository.saveRecord(record);
  
  // Scenario 2: Doctor views the patient's medical record
  print('\n--- Scenario 2: Doctor views the patient\'s medical record ---');
  record = repository.getRecordByPatientID(patientID);
  
  manager.setStrategy(ViewMedicalRecordStrategy());
  manager.processMedicalRecord(record!, doctorID, '');
  
  // Scenario 3: Doctor updates the patient's medical record
  print('\n--- Scenario 3: Doctor updates the patient\'s medical record ---');
  manager.setStrategy(UpdateMedicalRecordStrategy());
  manager.processMedicalRecord(
    record,
    doctorID,
    'Patient has a history of asthma and allergies to peanuts. Recent blood tests show normal ranges.'
  );
  repository.saveRecord(record);
  
  // Scenario 4: Patient views their updated medical record
  print('\n--- Scenario 4: Patient views their updated medical record ---');
  record = repository.getRecordByPatientID(patientID);
  
  manager.setStrategy(ViewMedicalRecordStrategy());
  manager.processMedicalRecord(record!, patientID, '');
  
  // Scenario 5: Patient updates their own medical record
  print('\n--- Scenario 5: Patient updates their own medical record ---');
  manager.setStrategy(UpdateMedicalRecordStrategy());
  manager.processMedicalRecord(
    record,
    patientID,
    'I have a history of asthma and allergies to peanuts. I also developed lactose intolerance recently.'
  );
  repository.saveRecord(record);
  
  // Scenario 6: Unauthorized user tries to access the record
  print('\n--- Scenario 6: Unauthorized user tries to access the record ---');
  manager.setStrategy(ViewMedicalRecordStrategy());
  manager.processMedicalRecord(record, 'UnauthorizedUser', '');
  
  // Scenario 7: Create a new patient without history and doctor adds it
  print('\n--- Scenario 7: Create a new patient without history and doctor adds it ---');
  final newPatientID = 'P002';
  var newRecord = repository.getRecordByPatientID(newPatientID);
  newRecord!.doctorID = doctorID;
  
  manager.setStrategy(AddMedicalRecordStrategy());
  manager.processMedicalRecord(
    newRecord,
    doctorID,
    'New patient with no prior medical conditions.'
  );
  repository.saveRecord(newRecord);
  
  // Print all medical records
  print('\n--- All Medical Records ---');
  print(record.toString());
  print(newRecord.toString());
}