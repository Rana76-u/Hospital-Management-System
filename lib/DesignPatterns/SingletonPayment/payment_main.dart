//To Run code, type in terminal:
//dart run lib/DesignPatterns/SingletonPayment/payment_main.dart

class PaymentProcessor {
  // Static instance variable to hold the singleton instance
  static PaymentProcessor? _instance;
  
  // Private constructor to prevent direct instantiation
  PaymentProcessor._() {
    print('PaymentProcessor initialized');
  }
  
  // Static getter method to access the singleton instance
  static PaymentProcessor get instance {
    // Create the instance if it doesn't exist yet
    _instance ??= PaymentProcessor._();
    return _instance!;
  }
  
  // Method to process payments
  void processPayment(double amount, String patientId, String description) {
    print('Processing payment of \$${amount.toStringAsFixed(2)} for patient $patientId');
    print('Description: $description');
    print('Payment processed successfully');
  }
  
  // Method to refund payments
  void refundPayment(String transactionId, double amount) {
    print('Refunding payment $transactionId of \$${amount.toStringAsFixed(2)}');
    print('Refund processed successfully');
  }
  
  // Method to check transaction status
  String checkTransactionStatus(String transactionId) {
    // In a real implementation, this would check a database or payment gateway
    print('Checking status of transaction $transactionId');
    return 'COMPLETED';
  }
}

// main.dart - Example usage

void main() {
  print('Hospital Management System - Payment Processing');
  print('-------------------------------------------------');
  
  // First access - this will initialize the singleton
  final paymentProcessor1 = PaymentProcessor.instance;
  
  // Process a payment
  paymentProcessor1.processPayment(150.75, 'P12345', 'Consultation fee');
  
  print('\nAttempting to access the instance again...');
  
  // Second access - should return the same instance
  final paymentProcessor2 = PaymentProcessor.instance;
  
  // Check if it's the same instance
  print('Are both references pointing to the same object? ${identical(paymentProcessor1, paymentProcessor2)}');
  
  // Use the second reference to process another payment
  print('\nUsing second reference to process another payment:');
  paymentProcessor2.processPayment(75.50, 'P54321', 'Medication cost');
  
  // Check transaction status
  print('\nChecking transaction status:');
  String status = PaymentProcessor.instance.checkTransactionStatus('TXN123456');
  print('Transaction status: $status');
  
  // Process refund
  print('\nProcessing refund:');
  paymentProcessor1.refundPayment('TXN123456', 25.00);
}