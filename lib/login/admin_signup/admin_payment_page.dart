import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:thesalesgong/data_classes/admin_signing_up.dart';
import 'package:thesalesgong/globals.dart' as globals;

class AdminPaymentPage extends StatefulWidget {
  final AdminSigningUp? adminSigningUp;
  const AdminPaymentPage({super.key, this.adminSigningUp});

  @override
  State<AdminPaymentPage> createState() => _AdminPaymentPageState();
}

class _AdminPaymentPageState extends State<AdminPaymentPage> {
  final double formPadding = 24;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    double totalPrice =
        (widget.adminSigningUp!.teamEmailAddresses!.length + 1) * 5.00;
    DateTime purchaseDate = DateTime.now();
    DateTime expirationDate = purchaseDate.add(const Duration(days: 30));

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
              _buildBreakdownItem('Team Members',
                  widget.adminSigningUp!.teamEmailAddresses!.length + 1),
              _buildBreakdownItem('Price per Email', '\$5.00'),
              _buildBreakdownItem('Subscription Duration', '1 month'),
              _buildBreakdownItem('Renewal Date',
                  DateFormat('MM/dd/yyyy').format(expirationDate)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Price",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '\$${totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
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
                onPressed: completePurchase,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text("COMPLETE"),
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
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600]),
          ),
          Text(
            '$value',
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
          ),
        ],
      ),
    );
  }

  void completePurchase() async {
    setState(() {
      _isLoading = true;
    });
    // await Purchases.setLogLevel(LogLevel.debug);

    // PurchasesConfiguration? configuration;

    // if (Platform.isAndroid){
    //   // configure for Google Play Store
    // } else if (Platform.isIOS){
    //   configuration = PurchasesConfiguration("appl_iTxQScKUYowxqRYgHvJbUnAAgKm");
    // }

    // if (configuration != null){
    //   await Purchases.configure(configuration);

    //   final paywallResult = await RevenueCatUI.presentPaywallIfNeeded("team_subscription");
    //   print('Paywall result: $paywallResult');
    //   log('Paywall result: $paywallResult');
    // }

    // Get fcm_token for push notiifcations
    final firebaseMessage = FirebaseMessaging.instance;
    await firebaseMessage.requestPermission();
    final fcmToken = await firebaseMessage.getToken();

    var body = {
      "name": widget.adminSigningUp!.displayName,
      "email": widget.adminSigningUp!.email,
      "password": widget.adminSigningUp!.password,
      "team_name": widget.adminSigningUp!.teamName,
      "team_members": widget.adminSigningUp!.teamEmailAddresses!.toString(),
      "fcm_token": fcmToken,
    };

    http.Response response = await http.post(
        Uri.parse("${globals.END_POINT}/sign_up/admin/complete_purchase"),
        body: body);

    if (response.statusCode == 201) {
      Map<String, dynamic> data = jsonDecode(response.body);
      const storage = FlutterSecureStorage();
      await storage.write(key: globals.FSS_TEAM_ID, value: data['team_ID']);
      await storage.write(
          key: globals.FSS_TEAM_NAME, value: widget.adminSigningUp!.teamName);
      await storage.write(key: globals.FSS_NEW_ACCOUNT, value: 'true');
    }
    if (context.mounted) {
      // Sign in to Firebase first
      try {
        FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: widget.adminSigningUp!.email,
                password: widget.adminSigningUp!.password)
            .then((value) async {
          // Sign in successful
          Navigator.pushNamed(context, '/home');
        });
      } on FirebaseException catch (e) {
        print('Firebase error: ${e.message}');
      }
    }

    if (context.mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
