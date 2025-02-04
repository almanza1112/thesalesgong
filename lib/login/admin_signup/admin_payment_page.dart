import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;
import 'package:purchases_flutter/purchases_flutter.dart';
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
    double totalTeamMembers =
        widget.adminSigningUp!.teamEmailAddresses!.length + 1;
    double totalPrice =
        (widget.adminSigningUp!.teamEmailAddresses!.length + 1) * 5.00;
    DateTime purchaseDate = DateTime.now();
    DateTime expirationDate = purchaseDate.add(const Duration(days: 30));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Payment'),
        elevation: 0,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color.fromRGBO(30, 58, 138, 1),
                Color.fromRGBO(79, 70, 229, 1)
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color.fromRGBO(30, 58, 138, 1),
              Color.fromRGBO(79, 70, 229, 1)
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildBreakdownItem(
                    'Team Members',
                    totalTeamMembers < 20
                        ? widget.adminSigningUp!.teamEmailAddresses!.length + 1
                        : 'Unlimited (20+)'),
                if (totalTeamMembers < 20)
                  _buildBreakdownItem('Price per Email', '\$5.00'),
                _buildBreakdownItem('Subscription Duration', '1 month'),
                // Removing the renewal date for now
                // TODO: add this back in the future when you find out how in-app purchases determines a month durantion for subscriptions
                // _buildBreakdownItem('Renewal Date',
                //     DateFormat('MM/dd/yyyy').format(expirationDate)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "TOTAL PRICE",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        totalTeamMembers > 20
                            ? '\$100.00'
                            : '\$${totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: const Color.fromRGBO(34, 197, 94, 1),
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
                color: Colors.grey[400]),
          ),
          Text(
            '$value',
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
          ),
        ],
      ),
    );
  }

  void completePurchase() async {
    setState(() {
      _isLoading = true;
    });

    await Purchases.setLogLevel(LogLevel.debug);

    PurchasesConfiguration? configuration;

    if (Platform.isAndroid) {
      // configure for Google Play Store
      configuration =
          PurchasesConfiguration("goog_YviRgSBzRKzcqhPFlpIaVENyfAz");
    } else if (Platform.isIOS) {
      configuration =
          PurchasesConfiguration("appl_iTxQScKUYowxqRYgHvJbUnAAgKm");
    }

    if (configuration != null) {
      await Purchases.configure(configuration);

      final totalTeamMembers =
          widget.adminSigningUp!.teamEmailAddresses!.length + 1;
      List<StoreProduct> productList;

      if (totalTeamMembers < 20) {
        productList = await Purchases.getProducts(
            ["thesalesgong_${totalTeamMembers}_person_team_sub"]);
      } else {
        productList = await Purchases.getProducts(
            ["thesalesgong_unlimited_person_team_sub"]);
      }

      try {
        CustomerInfo paywallResult =
            await Purchases.purchaseStoreProduct(productList.first);

        // Purchase was made succesfully and entitlements are active
        if (paywallResult.entitlements.active.values.first.isActive) {
          // Get fcm_token for push notiifcations
          final firebaseMessage = FirebaseMessaging.instance;
          await firebaseMessage.requestPermission();
          final fcmToken = await firebaseMessage.getToken();

          var body = {
            "name": widget.adminSigningUp!.displayName,
            "email": widget.adminSigningUp!.email,
            "password": widget.adminSigningUp!.password,
            "team_name": widget.adminSigningUp!.teamName,
            "team_members":
                widget.adminSigningUp!.teamEmailAddresses!.toString(),
            "fcm_token": fcmToken,
            "subscription_type": totalTeamMembers < 20
                ? "thesalesgong_${totalTeamMembers}_person_team_sub"
                : "thesalesgong_unlimited_person_team_sub",
          };

          http.Response response = await http.post(
              Uri.parse("${globals.END_POINT}/sign_up/admin/complete_purchase"),
              body: body);

          if (response.statusCode == 201) {
            Map<String, dynamic> data = jsonDecode(response.body);
            const storage = FlutterSecureStorage();
            await storage.write(
                key: globals.FSS_TEAM_ID, value: data['team_ID']);
            await storage.write(
                key: globals.FSS_TEAM_NAME,
                value: widget.adminSigningUp!.teamName);
            await storage.write(key: globals.FSS_NEW_ACCOUNT, value: 'true');

            await storage.write(
                key: globals.FSS_ROLE, value: globals.FSS_ADMIN);
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
        }
      } on PlatformException catch (e) {
        if (e.code == '1' &&
            e.details['readable_error_code'] == 'PURCHASE_CANCELLED') {
          // Handle the case where purchase was cancelled
          print('Purchase was cancelled.');
        } else {
          // Handle other cases
          print('Error: $e');
        }
      }
    }

    if (context.mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
