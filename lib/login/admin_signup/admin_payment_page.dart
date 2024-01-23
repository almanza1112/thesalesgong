import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminPaymentPage extends StatefulWidget {
  const AdminPaymentPage({Key? key}) : super(key: key);

  @override
  State<AdminPaymentPage> createState() => _AdminPaymentPageState();
}

class _AdminPaymentPageState extends State<AdminPaymentPage> {
  final double formPadding = 24;

  @override
  Widget build(BuildContext context) {
    late List<String> receivedEmailAddresses;

    final List<String> args =
        ModalRoute.of(context)!.settings.arguments as List<String>;
    receivedEmailAddresses = args;

    double totalPrice = receivedEmailAddresses.length * 9.99;
    DateTime purchaseDate = DateTime.now();
    DateTime expirationDate = purchaseDate.add(const Duration(days: 365));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.white10,
        foregroundColor: Colors.grey[600],
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
             

              _buildBreakdownItem(
                  'Team Members', receivedEmailAddresses.length),
              _buildBreakdownItem('Price per Email', 9.99),
              _buildBreakdownItem('Subscription Duration', '1 Year'),
              _buildBreakdownItem('Expiration Date',
                  DateFormat('MM/dd/yyyy').format(expirationDate)),

                   
Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         const Text(
            "Total Price",
            style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w700),
          ),
          Text(
            '\$${totalPrice.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black),
          ),
        ],
      ),
    ),
              const Spacer(),
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white, // Modern color
                  shape: const StadiumBorder(),
                ),
                onPressed: () {
                  // Handle checkout logic here
                  Navigator.pushNamed(context, '/home');
                },
                child: const Text("COMPLETE"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBreakdownItem(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey[600]),
          ),
          Text(
            '$value',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
