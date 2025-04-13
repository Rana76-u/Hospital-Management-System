//To Run code, type in terminal:
//dart run lib/DesignPatterns/SingletonPayment/payment_main.dart

class PaymentProcessor {
  // Private static instance variable
  static PaymentProcessor? _instance;

  // Attributes
  String? paymentID;
  String? patientID;
  double totalAmount = 0.0;
  String paymentStatus = 'Pending';

  // Private constructor
  PaymentProcessor._internal();

  // Static method to get the instance
  static PaymentProcessor getInstance() {
    // Create the instance if it doesn't exist yet
    _instance ??= PaymentProcessor._internal();
    return _instance!;
  }

  // Method to process payment
  void processPayment() {
    if (patientID == null || patientID!.isEmpty) {
      print('Error: Patient ID is required');
      return;
    }

    if (totalAmount <= 0) {
      print('Error: Total amount must be greater than zero');
      return;
    }

    // Generate a unique payment ID (in a real system, this would be more sophisticated)
    paymentID = 'PAY-${DateTime.now().millisecondsSinceEpoch}';
    
    // Payment processing logic
    print('Processing payment...');
    print('Payment ID: $paymentID');
    print('Patient ID: $patientID');
    print('Amount: \$${totalAmount.toStringAsFixed(2)}');
    
    // Simulate payment success
    paymentStatus = 'Completed';
    print('Payment status: $paymentStatus');
  }
}

// main.dart - Demo usage
void main() {
  // Get the singleton instance
  final paymentProcessor = PaymentProcessor.getInstance();
  
  // Set payment details
  paymentProcessor.patientID = 'P001';
  paymentProcessor.totalAmount = 250.50;
  
  // Process the payment
  paymentProcessor.processPayment();
  
  // Prove it's a singleton by getting another "instance"
  final anotherReference = PaymentProcessor.getInstance();
  
  // Check if they are the same instance
  print('\nSingleton test:');
  print('Is same instance? ${identical(paymentProcessor, anotherReference)}');
  
  // We can access the previous payment's details through the new reference
  print('Payment ID from second reference: ${anotherReference.paymentID}');
  print('Payment status from second reference: ${anotherReference.paymentStatus}');
  
  // Process another payment using the second reference
  print('\nProcessing another payment:');
  anotherReference.patientID = 'P002';
  anotherReference.totalAmount = 175.25;
  anotherReference.processPayment();
  
  // Show that the first reference also reflects these changes
  print('\nFirst reference now shows:');
  print('Patient ID: ${paymentProcessor.patientID}');
  print('Payment ID: ${paymentProcessor.paymentID}');
}