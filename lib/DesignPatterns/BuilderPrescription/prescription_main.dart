//To Run code, type in terminal:
//dart run lib/DesignPatterns/BuilderPrescription/prescription_main.dart

// Prescription model
class Prescription {
  final String patientName;
  final String doctorName;
  final DateTime prescriptionDate;
  final List<Medicine> medicines;
  final String diagnosis;
  final List<String> instructions;
  final int validityDays;
  final bool followUpRequired;
  final DateTime? followUpDate;

  Prescription._({
    required this.patientName,
    required this.doctorName,
    required this.prescriptionDate,
    required this.medicines,
    required this.diagnosis,
    required this.instructions,
    required this.validityDays,
    required this.followUpRequired,
    this.followUpDate,
  });

  @override
  String toString() {
    StringBuffer sb = StringBuffer();
    sb.writeln('===== PRESCRIPTION =====');
    sb.writeln('Patient: $patientName');
    sb.writeln('Doctor: $doctorName');
    sb.writeln('Date: ${prescriptionDate.toString().substring(0, 10)}');
    sb.writeln('Diagnosis: $diagnosis');
    sb.writeln('\nMEDICINES:');
    for (var medicine in medicines) {
      sb.writeln('- ${medicine.toString()}');
    }
    sb.writeln('\nINSTRUCTIONS:');
    for (var instruction in instructions) {
      sb.writeln('- $instruction');
    }
    sb.writeln('\nValidity: $validityDays days');
    sb.writeln('Follow-up Required: $followUpRequired');
    if (followUpDate != null) {
      sb.writeln('Follow-up Date: ${followUpDate.toString().substring(0, 10)}');
    }
    sb.writeln('========================');
    return sb.toString();
  }
}

// Medicine model
class Medicine {
  final String name;
  final String dosage;
  final String frequency;
  final int durationDays;
  final String? specialInstructions;

  Medicine({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.durationDays,
    this.specialInstructions,
  });

  @override
  String toString() {
    String result = '$name ($dosage) - $frequency for $durationDays days';
    if (specialInstructions != null) {
      result += ' - Special instructions: $specialInstructions';
    }
    return result;
  }
}

// Builder for Medicine
class MedicineBuilder {
  String _name = '';
  String _dosage = '';
  String _frequency = '';
  int _durationDays = 0;
  String? _specialInstructions;

  MedicineBuilder name(String name) {
    _name = name;
    return this;
  }

  MedicineBuilder dosage(String dosage) {
    _dosage = dosage;
    return this;
  }

  MedicineBuilder frequency(String frequency) {
    _frequency = frequency;
    return this;
  }

  MedicineBuilder durationDays(int days) {
    _durationDays = days;
    return this;
  }

  MedicineBuilder specialInstructions(String instructions) {
    _specialInstructions = instructions;
    return this;
  }

  Medicine build() {
    return Medicine(
      name: _name,
      dosage: _dosage,
      frequency: _frequency,
      durationDays: _durationDays,
      specialInstructions: _specialInstructions,
    );
  }
}

// Builder for Prescription
class PrescriptionBuilder {
  String _patientName = '';
  String _doctorName = '';
  late DateTime _prescriptionDate;
  List<Medicine> _medicines = [];
  String _diagnosis = '';
  List<String> _instructions = [];
  int _validityDays = 30; // Default validity
  bool _followUpRequired = false;
  DateTime? _followUpDate;

  PrescriptionBuilder() {
    _prescriptionDate = DateTime.now(); // Default to current date
  }

  PrescriptionBuilder patientName(String name) {
    _patientName = name;
    return this;
  }

  PrescriptionBuilder doctorName(String name) {
    _doctorName = name;
    return this;
  }

  PrescriptionBuilder prescriptionDate(DateTime date) {
    _prescriptionDate = date;
    return this;
  }

  PrescriptionBuilder addMedicine(Medicine medicine) {
    _medicines.add(medicine);
    return this;
  }

  PrescriptionBuilder diagnosis(String diagnosis) {
    _diagnosis = diagnosis;
    return this;
  }

  PrescriptionBuilder addInstruction(String instruction) {
    _instructions.add(instruction);
    return this;
  }

  PrescriptionBuilder validityDays(int days) {
    _validityDays = days;
    return this;
  }

  PrescriptionBuilder requireFollowUp(bool required) {
    _followUpRequired = required;
    return this;
  }

  PrescriptionBuilder   followUpDate(DateTime? date) {
    _followUpDate = date;
    _followUpRequired = date != null;
    return this;
  }

  Prescription build() {
    if (_patientName.isEmpty) {
      throw ArgumentError('Patient name is required');
    }
    
    if (_doctorName.isEmpty) {
      throw ArgumentError('Doctor name is required');
    }
    
    if (_medicines.isEmpty) {
      throw ArgumentError('At least one medicine must be prescribed');
    }

    return Prescription._(
      patientName: _patientName,
      doctorName: _doctorName,
      prescriptionDate: _prescriptionDate,
      medicines: _medicines,
      diagnosis: _diagnosis,
      instructions: _instructions,
      validityDays: _validityDays,
      followUpRequired: _followUpRequired,
      followUpDate: _followUpDate,
    );
  }
}

// Director class to create common prescription types
class PrescriptionDirector {
  static Prescription createStandardPrescription(String patientName, String doctorName, String diagnosis) {
    PrescriptionBuilder builder = PrescriptionBuilder()
        .patientName(patientName)
        .doctorName(doctorName)
        .diagnosis(diagnosis)
        .validityDays(30)
        .requireFollowUp(false);
        
    // Add a default medicine to pass validation
    Medicine defaultMedicine = MedicineBuilder()
        .name("Paracetamol")
        .dosage("500mg")
        .frequency("as needed")
        .durationDays(3)
        .build();
    
    builder.addMedicine(defaultMedicine);
    
    return builder.build();
  }

  static Prescription createChronicConditionPrescription(String patientName, String doctorName, String diagnosis) {
    PrescriptionBuilder builder = PrescriptionBuilder()
        .patientName(patientName)
        .doctorName(doctorName)
        .diagnosis(diagnosis)
        .validityDays(90)
        .requireFollowUp(true)
        .followUpDate(DateTime.now().add(Duration(days: 30)))
        .addInstruction("Monitor blood pressure daily")
        .addInstruction("Keep a log of symptoms");
        
    // Here we need a medicine before building
    Medicine sampleMedicine = MedicineBuilder()
        .name("Sample Medicine")
        .dosage("N/A")
        .frequency("As prescribed")
        .durationDays(90)
        .build();
    
    builder.addMedicine(sampleMedicine);
    
    return builder.build();
  }
}

// Main function to demonstrate
void main() {
  // Create a medicine using builder
  Medicine paracetamol = MedicineBuilder()
      .name("Paracetamol")
      .dosage("500mg")
      .frequency("3 times a day")
      .durationDays(5)
      .specialInstructions("Take after meals")
      .build();

  Medicine amoxicillin = MedicineBuilder()
      .name("Amoxicillin")
      .dosage("250mg")
      .frequency("twice a day")
      .durationDays(7)
      .build();

  // Create a prescription using builder
  try {
    Prescription prescription = PrescriptionBuilder()
        .patientName("John Doe")
        .doctorName("Dr. Smith")
        .prescriptionDate(DateTime.now())
        .diagnosis("Acute respiratory infection")
        .addMedicine(paracetamol)
        .addMedicine(amoxicillin)
        .addInstruction("Rest for at least 3 days")
        .addInstruction("Drink plenty of fluids")
        .validityDays(14)
        .requireFollowUp(true)
        .followUpDate(DateTime.now().add(Duration(days: 10)))
        .build();

    print(prescription);

    // Using director to create a standard prescription
    print("\nCreating a standard prescription using director...");
    Prescription standardPrescription = PrescriptionDirector.createStandardPrescription(
        "Alice Johnson", 
        "Dr. Wilson", 
        "Common cold"
    );
    
    // Need to add medicines as they're required
    standardPrescription = PrescriptionBuilder()
        .patientName(standardPrescription.patientName)
        .doctorName(standardPrescription.doctorName)
        .diagnosis(standardPrescription.diagnosis)
        .validityDays(standardPrescription.validityDays)
        .requireFollowUp(standardPrescription.followUpRequired)
        .addMedicine(paracetamol)
        .addInstruction("Rest well")
        .build();
    
    print(standardPrescription);

    // Using director to create a chronic condition prescription
    print("\nCreating a chronic condition prescription using director...");
    Prescription chronicPrescription = PrescriptionDirector.createChronicConditionPrescription(
        "Bob Smith", 
        "Dr. Brown", 
        "Hypertension"
    );
    
    Medicine lisinopril = MedicineBuilder()
        .name("Lisinopril")
        .dosage("10mg")
        .frequency("once daily")
        .durationDays(90)
        .build();
        
    chronicPrescription = PrescriptionBuilder()
        .patientName(chronicPrescription.patientName)
        .doctorName(chronicPrescription.doctorName)
        .diagnosis(chronicPrescription.diagnosis)
        .validityDays(chronicPrescription.validityDays)
        .requireFollowUp(chronicPrescription.followUpRequired)
        .followUpDate(chronicPrescription.followUpDate)
        .addMedicine(lisinopril)
        .addInstruction(chronicPrescription.instructions[0])
        .addInstruction(chronicPrescription.instructions[1])
        .build();
    
    print(chronicPrescription);
    
  } catch (e) {
    print("Error: $e");
  }
}