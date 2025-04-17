import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Core/Snackbar/custom_snackbars.dart';
import '../../DesignPatterns/StrategyBilling/strategy_billing.dart';

//Just a helper class
class _BillingOption {
  final String label;
  final BillingStrategy strategy;

  _BillingOption(this.label, this.strategy);
}

class BillingPage extends StatefulWidget {
  final String appointmentId;
  const BillingPage({super.key, required this.appointmentId});

  @override
  _BillingPageState createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  final BillingContext _context = BillingContext(RegularBilling());

  num consultationFee = 0;
  double? _finalAmount;

  final List<_BillingOption> _billingOptions = [
    _BillingOption("SSLCommerz", RegularBilling()),
    _BillingOption("10% Discount On Bkash Payment", BasicDiscountBilling()),
    _BillingOption("15% Discount On Visa/Master Card Payment", PremiumDiscountBilling()),
  ];

  _BillingOption? _selectedOption;

  void _onCalculate() {
    setState(() {
      _finalAmount = _context.calculateBill(consultationFee.toDouble());
    });
  }

  void _onStrategyChanged(BillingStrategy strategy) {
    setState(() {
      _context.setStrategy(strategy);
      _finalAmount = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Billing & Payment Strategy")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FutureBuilder(
                future: FirebaseFirestore
                    .instance
                    .collection('appointments')
                    .doc(widget.appointmentId)
                    .get(),
                builder: (context, snapshot) {
                  String doctorID = snapshot.data!.get('doctorID');

                  if(snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  else{
                    return FutureBuilder(
                      future: FirebaseFirestore
                          .instance
                          .collection('user')
                          .doc(doctorID)
                          .get(),
                      builder: (context, snapshot) {
                        consultationFee = snapshot.data!.get('consultation_fee');
                        if(snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        else{
                          return Text(
                            "Consultation Fee: $consultationFee",
                            style: TextStyle(fontSize: 18),
                          );
                        }
                      },
                    );
                  }
                },
            ),
            SizedBox(height: 20),
            Text("Select Billing Methods:"),
            Column(
              children: _billingOptions.map((option) {
                final isSelected = _selectedOption == option;
                return CheckboxListTile(
                  title: Text(option.label),
                  value: isSelected,
                  onChanged: (_) {
                    setState(() {
                      _selectedOption = option;
                      _context.setStrategy(option.strategy);
                      _onStrategyChanged(option.strategy);
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _onCalculate,
              child: Text("Calculate Final Amount"),
            ),
            SizedBox(height: 20),
            if (_finalAmount != null) ...[
              Text("Selected Strategy: ${_context.getStrategyDescription()}", style: TextStyle(fontSize: 16)),
              Text("Final Amount: ${_finalAmount!.toStringAsFixed(0)} Tk", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30,),
              ElevatedButton(
                  onPressed: () {
                    FirebaseFirestore.instance.collection('appointments').doc(widget.appointmentId).update({
                      'paymentStatus': 'paid',
                    });
                    CustomSnackBar().openIconSnackBar(
                        context, 'Payment Successful', Icon(Icons.done, color: Colors.white,)
                    );
                    Navigator.of(context).pop();
                  },
                  child: Text('Proceed to Payment')
              )
            ]
          ],
        ),
      ),
    );
  }
}
