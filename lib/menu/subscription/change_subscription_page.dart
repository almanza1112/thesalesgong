import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:thesalesgong/globals.dart' as globals;
import 'package:thesalesgong/menu/subscription/remove_team_members_page.dart';
import 'package:url_launcher/url_launcher.dart';

class ChangeSubscriptionPage extends StatefulWidget {
  const ChangeSubscriptionPage({super.key});

  @override
  State<ChangeSubscriptionPage> createState() => _ChangeSubscriptionPageState();
}

class _ChangeSubscriptionPageState extends State<ChangeSubscriptionPage> {
  final flutterSecureStorage = const FlutterSecureStorage();

  TextStyle get _changeSubscriptionOptionsStyle =>
      const TextStyle(color: Colors.white, fontSize: 16);

  TextStyle get _selectedStyle =>
      const TextStyle(color: Colors.black, fontSize: 16);

  TextStyle get _subtitleUnselectedStyle =>
      TextStyle(color: Colors.grey[400], fontSize: 14);

  TextStyle get _subtitleSelectedStyle =>
      TextStyle(color: Colors.grey[600], fontSize: 14);

  bool _isChangingLoading = false;
  int _currentTeamSize = 0;

  List<String> _listFromRemovedTeamMembers = [];
  bool _hadToRemoveTeamMembers = false;

  // List of team sizes
  final List<String> _teamSizes =
      List.generate(19, (index) => '${index + 2} Person Team Subscription');

  // List prices and duration
  final List<String> _priceAndDuration =
      List.generate(19, (index) => '\$${(index + 2) * 5} / Month');

  @override
  void initState() {
    super.initState();
    _fetchSubscriptionData();
  }

  Future<void> _fetchSubscriptionData() async {
    setState(() {
      _isChangingLoading = true;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      final data = snapshot.data() as Map<String, dynamic>;
      setState(() {
        _currentTeamSize = data['subscription']['total_team_members_allowed'];
        _isChangingLoading = false;
      });
    } catch (e) {
      // Handle any errors here
      setState(() {
        _isChangingLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int adjustedTeamSize = _currentTeamSize - 2;

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
        child: Stack(
          children: [
            SafeArea(
              child: CupertinoScrollbar(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                          children: [
                            const TextSpan(
                              text:
                                  'You can change your subscription below by selecting the number of team members you would like to have. \n\nYou can cancel your subscription at any time from your Apple ID settings. To learn more, visit our ',
                            ),
                            TextSpan(
                              text: 'Terms of Service',
                              style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  const url =
                                      'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/';
                                  if (await canLaunchUrl(Uri.parse(url))) {
                                    await launchUrl(Uri.parse(url));
                                  }
                                },
                            ),
                            const TextSpan(
                              text: ' and ',
                            ),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  const url =
                                      'https://www.freeprivacypolicy.com/live/e28a54d6-def7-4953-bc07-9fd0527b4f31';
                                  if (await canLaunchUrl(Uri.parse(url))) {
                                    await launchUrl(Uri.parse(url));
                                  }
                                },
                            ),
                            const TextSpan(
                              text: '.\n',
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _teamSizes.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                    color: Colors.grey.withOpacity(0.9)),
                              ),
                              color: adjustedTeamSize == index
                                  ? Colors.grey[200]
                                  : Colors.black.withOpacity(
                                      0.2), // Dark color with opacity
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () {
                                  // Check if new change is greater than current team size
                                  if (index + 2 > _currentTeamSize) {
                                    // It is greater
                                    // Update subscription
                                    _updateSubscription(index + 2);
                                  } else if (index + 2 == _currentTeamSize) {
                                    // It is the selected tile, do NOTHING
                                  } else {
                                    // It is less than, the user must remove team members
                                    _checkForTeamMembersRemoval(index + 2);
                                  }
                                },
                                child: ListTile(
                                  title: Text(
                                    index == 18
                                        ? "Unlimited Team Subscription"
                                        : _teamSizes[index],
                                    style: adjustedTeamSize == index
                                        ? _selectedStyle
                                        : _changeSubscriptionOptionsStyle,
                                  ),
                                  subtitle: Text(
                                    _priceAndDuration[index],
                                    style: adjustedTeamSize == index
                                        ? _subtitleSelectedStyle
                                        : _subtitleUnselectedStyle,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_isChangingLoading)
              Container(
                color: Colors.black.withOpacity(0.4),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _updateSubscription(int totalTeamMembers) async {
    setState(() {
      _isChangingLoading = true;
    });
    await Purchases.setLogLevel(LogLevel.debug);

    PurchasesConfiguration? configuration;

    if (Platform.isAndroid) {
      // configure for Google Play Store
    } else if (Platform.isIOS) {
      configuration = PurchasesConfiguration(globals.REVENUECAT_APPLE_KEY);
    }

    if (configuration != null) {
      await Purchases.configure(configuration);

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
          // Updating the current team size here to avoid ensure the UI is updated when purchase is successful
          setState(() {
            _currentTeamSize = totalTeamMembers;
          });

          if (_hadToRemoveTeamMembers) {
            _emailsToBeRemoved();
          } else {
            _updateDatabase();
          }
        }
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

  void _updateDatabase() async {
    String? teamID = await flutterSecureStorage.read(key: globals.FSS_TEAM_ID);

    // Using a batch job to update the user doc of the admin and the team doc
    final batch = FirebaseFirestore.instance.batch();

    var userRef = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid);
    batch.update(userRef, {
      'subscription': {
        'status': 'active',
        'total_team_members_allowed': _currentTeamSize,
        'type': _currentTeamSize < 20
            ? 'thesalesgong_${_currentTeamSize}_person_team_sub'
            : 'thesalesgong_unlimited_person_team_sub'
      }
    });

    var teamRef = FirebaseFirestore.instance.collection("teams").doc(teamID);
    batch.update(teamRef, {"total_team_members_allowed": _currentTeamSize});

    batch.commit().then((value) {
      setState(() {
        _isChangingLoading = false;
      });

      Navigator.of(context).pop();
    }).catchError((onError) {
      setState(() {
        _isChangingLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again.'),
        ),
      );
    });
  }

  void _checkForTeamMembersRemoval(int totalTeamMembers) async {
    // Check if the user has correct amount of team members for new subscription (that is less than current)
    // The reasoning behind this is that the user must remove team members before they can downgrade their subscription
    // Also the admin has the ability to remove team members and team members have the ability to remove themselves / delete their account

    String? teamID = await flutterSecureStorage.read(key: globals.FSS_TEAM_ID);

    FirebaseFirestore.instance
        .collection("teams")
        .doc(teamID)
        .get()
        .then((value) {
      if (value.exists) {
        final data = value.data() as Map<String, dynamic>;
        List<dynamic> emails = data['emails'];

        // Check if user has enough team members to downgrade
        if (emails.length <= totalTeamMembers) {
          _updateSubscription(totalTeamMembers);
        } else {
          // User must remove team members for it to equal the new subscription
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RemoveTeamMembersPage(
                onListUpdated: _updateEmailsToBeRemoved,
                teamID: teamID!,
                totalNewMembers: totalTeamMembers,
              ),
            ),
          );
        }
      }
    }).catchError((onError) {
      // Handle error
    });
  }

  void _updateEmailsToBeRemoved(List<String> emails, int totalTeamMembers) {
    setState(() {
      _listFromRemovedTeamMembers = emails;
      _hadToRemoveTeamMembers = true;
    });
    _updateSubscription(totalTeamMembers);
  }

  void _emailsToBeRemoved() async {
    String? teamID = await flutterSecureStorage.read(key: globals.FSS_TEAM_ID);

    FirebaseFirestore.instance
        .collection("teams")
        .doc(teamID)
        .get()
        .then((value) {
      if (value.exists) {
        final data = value.data() as Map<String, dynamic>;
        List<dynamic> teamMembers = data['emails'];
        List<dynamic> registeredTeamMembers = data['registered_team_members'];

        // Remove the emails from the teamMembers list
        teamMembers.removeWhere(
            (element) => _listFromRemovedTeamMembers.contains(element));

        // Remove the emails from the registeredTeamMembers list
        registeredTeamMembers.removeWhere((element) {
          return _listFromRemovedTeamMembers.contains(element['email']);
        });

        final batch = FirebaseFirestore.instance.batch();

        var teamRef =
            FirebaseFirestore.instance.collection("teams").doc(teamID);
        batch.update(teamRef, {
          "emails": teamMembers,
          'registered_team_members': registeredTeamMembers,
          "total_team_members_allowed": teamMembers.length
        });

        var userRef = FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid);

        batch.update(userRef, {
          'subscription': {
            'status': 'active',
            'total_team_members_allowed': _currentTeamSize,
            'type': 'thesalesgong_${_currentTeamSize}_person_team_sub'
          }
        });

        batch.commit().then((value) {
          setState(() {
            _isChangingLoading = false;
          });

          Navigator.of(context).pop();
        }).catchError((onError) {
          setState(() {
            _isChangingLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('An error occurred. Please try again.'),
            ),
          );
        });
      }
    }).catchError((onError) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again.'),
        ),
      );
    });
  }
}
