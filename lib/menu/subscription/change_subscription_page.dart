import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:thesalesgong/globals.dart' as globals;

class ChangeSubscriptionPage extends StatefulWidget {
  const ChangeSubscriptionPage({super.key});

  @override
  State<ChangeSubscriptionPage> createState() => _ChangeSubscriptionPageState();
}

class _ChangeSubscriptionPageState extends State<ChangeSubscriptionPage> {
  TextStyle get _changeSubscriptionOptionsStyle =>
      const TextStyle(color: Colors.white, fontSize: 16);
  TextStyle get _selectedStyle =>
      const TextStyle(color: Colors.black, fontSize: 16);

  bool _isChangingLoading = false;

  // List of team sizes
  final List<String> _teamSizes =
      List.generate(19, (index) => '${index + 2} Person Team Subsciption');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Subscription'),
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection("users")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final data = snapshot.data as DocumentSnapshot;
                  int teamSize =
                      data['subscription']['total_team_members_allowed'];
                  int adjustedTeamSize = teamSize - 2;

                  return ListView.builder(
                    itemCount: _teamSizes.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.grey.withOpacity(0.9)),
                        ),
                        color: adjustedTeamSize == index
                            ? Colors.grey[200]
                            : Colors.black
                                .withOpacity(0.2), // Dark color with opacity
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            // Check if new change is greater than current team size
                            if (index + 2 > teamSize) {
                              // It is greater
                              // Update subscription
                              _updateSubscription(index + 2);
                            } else {
                              // It is less than so admin needs to pick team member to be removed
                              print('nooo');
                            }
                            
                          },
                          child: ListTile(
                            title: Text(
                              _teamSizes[index],
                              style: adjustedTeamSize == index
                                  ? _selectedStyle
                                  : _changeSubscriptionOptionsStyle,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
          ),
        ),
      ),
    );
  }

  void _updateSubscription(int totalTeamMembers) async {
    await Purchases.setLogLevel(LogLevel.debug);

    PurchasesConfiguration? configuration;

    if (Platform.isAndroid) {
      // configure for Google Play Store
    } else if (Platform.isIOS) {
      configuration = PurchasesConfiguration(globals.REVENUECAT_APPLE_KEY);
    }

    if (configuration != null) {
      await Purchases.configure(configuration);

      List<StoreProduct> productList = await Purchases.getProducts(
          ["thesalesgong_${totalTeamMembers}_person_team_sub"]);
      try {
        CustomerInfo paywallResult =
            await Purchases.purchaseStoreProduct(productList.first);

        // Purchase was made succesfully and entitlements are active
        if (paywallResult.entitlements.active.values.first.isActive) {}
      } on PlatformException catch (e) {
        if (context.mounted) {
          setState(() {
            _isChangingLoading = false;
          });
        }
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
  }
}
