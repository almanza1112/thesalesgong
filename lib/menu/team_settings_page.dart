import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:thesalesgong/data_classes/team_members.dart';
import 'package:http/http.dart' as http;
import 'package:thesalesgong/globals.dart' as globals;

class TeamPage extends StatefulWidget {
  final String? teamId;
  const TeamPage({super.key, this.teamId});
  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  final storage = const FlutterSecureStorage();
  final firestore = FirebaseFirestore.instance;

  String teamName = '';
  String role = '';
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeTeamName();
  }

  Future<void> _initializeTeamName() async {
    teamName = await storage.read(key: "team_name") ?? "Team";
    role = await storage.read(key: globals.FSS_ROLE) ?? "team_member";
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(teamName),
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
          actions: [
            // Make sure only the admin can add new team members
            if (role == globals.FSS_ADMIN)
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: addTeamMember,
              ),
          ],
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
          child: StreamBuilder(
            stream:
                firestore.collection("teams").doc(widget.teamId).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                Map<String, dynamic> team =
                    snapshot.data!.data() as Map<String, dynamic>;
                List registeredTeamMembers = team["registered_team_members"];
                List emails = team["emails"];
                String notRegisteredYet = "Not registered yet";

                List<TeamMember> teamMembers = [];

                for (var i = 0; i < emails.length; i++) {
                  String email = emails[i];
                  if (registeredTeamMembers
                      .any((member) => member["email"] == email)) {
                    // Email is registered, add team member details
                    var registeredMember = registeredTeamMembers
                        .firstWhere((member) => member["email"] == email);
                    teamMembers.add(TeamMember(
                      email: email,
                      name: registeredMember["name"],
                      role: registeredMember["role"],
                    ));
                  } else {
                    // Email is not registered, add default details
                    teamMembers.add(TeamMember(
                      email: email,
                      name: notRegisteredYet,
                      role: "team_member",
                    ));
                  }
                }

                return ListView.builder(
                  itemCount: teamMembers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: teamMembers[index].name == notRegisteredYet
                              ? Colors.grey[200]
                              : Colors.blue[100],
                          //border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListTile(
                          leading: teamMembers[index].role == "team_member"
                              ? const Icon(Icons.people)
                              : const Icon(Icons.person),
                          title: Text(teamMembers[index].email),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(teamMembers[index].name,
                                  style: teamMembers[index].name ==
                                          notRegisteredYet
                                      ? const TextStyle(
                                          fontStyle: FontStyle.italic)
                                      : null),
                              Text(teamMembers[index].role == "team_member"
                                  ? "Team Member"
                                  : "Admin"),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ));
  }

  void addTeamMember() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Email Address'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email Address'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  //Navigator.of(context).pop(); // Close the dialog
                  //_addEmailAddress(_emailController.text);
                  firestore.collection("teams").doc(widget.teamId).get().then(
                    (value) async {
                      List emails = value.data()!["emails"];
                      final totalEmails = emails.length + 1;
                      await Purchases.setLogLevel(LogLevel.debug);

                      PurchasesConfiguration? configuration;

                      if (Platform.isAndroid) {
                        // configure for Google Play Store
                      } else if (Platform.isIOS) {
                        configuration = PurchasesConfiguration(
                            "appl_iTxQScKUYowxqRYgHvJbUnAAgKm");
                      }

                      if (configuration != null) {
                        await Purchases.configure(configuration);

                        List<StoreProduct> productList =
                            await Purchases.getProducts([
                          "thesalesgong_${totalEmails}_person_team_sub"
                        ]);

                        try {
                          CustomerInfo paywallResult =
                              await Purchases.purchaseStoreProduct(
                                  productList.first);

                          // Purchase was made succesfully and entitlements are active
                          if (paywallResult
                              .entitlements.active.values.first.isActive) {
                            _addEmailAddress(_emailController.text);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Purchase failed'),
                              ),
                            );
                          }
                          Navigator.of(context).pop(); // Close the dialog
                        } on PlatformException catch (e) {
                          if (e.code == '1' &&
                              e.details['readable_error_code'] ==
                                  'PURCHASE_CANCELLED') {
                            // Handle the case where purchase was cancelled
                            print('Purchase was cancelled.');
                          } else {
                            // Handle other cases
                            print('Error: $e');
                          }
                        }
                      }
                    },
                  );
                },
                child: const Text('ADD'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addEmailAddress(String emailAddress) async {
    if (emailAddress.isNotEmpty) {
      var body = {
        "team_ID": widget.teamId,
        "email": emailAddress,
        "team_name": teamName,
      };

      http.Response response = await http.post(
          Uri.parse("${globals.END_POINT}/account/add_teammember"),
          body: body);

      if (response.statusCode == 201) {
      } else if (response.statusCode == 409) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email address already exists'),
            ),
          );
        }
      }
    }
  }
}
