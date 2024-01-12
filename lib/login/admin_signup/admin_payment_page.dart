import 'package:flutter/material.dart';

class AdminPaymentPage extends StatefulWidget {
  const AdminPaymentPage({Key? key}) : super(key: key);
  @override
  State<AdminPaymentPage> createState() => _AdminPaymentPageState();
}

class _AdminPaymentPageState extends State<AdminPaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _expController = TextEditingController();

  final double formPadding = 24;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.white10,
        foregroundColor: Colors.grey[600],
        shadowColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: formPadding),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      labelText: 'Name on Card',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the name on card';
                    }
                    return null;
                  },
                ),
                SizedBox(height: formPadding),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                      labelText: 'Card Billing Address',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: const Icon(
                        Icons.pin_drop,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the card billing address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: formPadding),
                TextFormField(
                  controller: _cardNumberController,
                  decoration: InputDecoration(
                      labelText: 'Card Number',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: const Icon(
                        Icons.credit_card,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the card number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: formPadding),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _cvvController,
                        decoration: InputDecoration(
                            labelText: 'CVV',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            prefixIcon: const Icon(
                              Icons.numbers,
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40))),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the CVV';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _expController,
                        decoration: InputDecoration(
                            labelText: 'Exp.',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            prefixIcon: const Icon(
                              Icons.date_range,
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40))),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the expiration date';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                TextButton(
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder()),
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  },
                  child: const Text("COMPLETE"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
