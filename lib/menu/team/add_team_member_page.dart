import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:thesalesgong/globals.dart' as globals;
import 'package:purchases_flutter/purchases_flutter.dart';

class AddTeamMemberPage extends StatefulWidget {
  final teamId;
  final teamName;
  const AddTeamMemberPage({super.key, this.teamId, this.teamName});

  @override
  State<AddTeamMemberPage> createState() => _AddTeamMemberPageState();
}

class _AddTeamMemberPageState extends State<AddTeamMemberPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<String> _emailAddresses = [];

  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  bool _isDialogLoading = false;
  String? _emailErrorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Team Member'),
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
          IconButton(
            onPressed: _showAddDialog,
            icon: const Icon(Icons.add),
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
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: AnimatedList(
                  key: _listKey,
                  initialItemCount: _emailAddresses.length,
                  itemBuilder: (context, index, animation) {
                    return _buildItem(_emailAddresses[index], animation);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: const Color.fromRGBO(34, 197, 94, 1),
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.blue),
                      shape: const StadiumBorder()),
                  onPressed: _updateTeamMembers,
                  //onPressed: () => _addEmailAddresstoDB(_emailAddresses), // for testing, bypassing the purchase
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('UPDATE'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add Email Address'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: 'Email Address', errorText: _emailErrorText),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () async {
                    setState(() {
                      _isDialogLoading = true;
                      _emailErrorText = null;
                    });
                    var body = {"email": _emailController.text};

                    http.Response response = await http.post(
                        Uri.parse("${globals.END_POINT}/account/check_email"),
                        body: body);

                    if (response.statusCode == 201) {
                      setState(() {
                        _isDialogLoading = false;
                      });
                      Navigator.of(context).pop(); // Close the dialog
                      _addEmailAddress(_emailController.text);
                    } else if (response.statusCode == 409) {
                      setState(() {
                        _isDialogLoading = false;
                        _emailErrorText = "Email address already exists";
                      });
                    }
                  },
                  child: _isDialogLoading
                      ? const CircularProgressIndicator()
                      : const Text('ADD'),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  void _addEmailAddress(String emailAddress) {
    if (emailAddress.isNotEmpty) {
      _emailAddresses.insert(0, emailAddress);
      _listKey.currentState
          ?.insertItem(0, duration: const Duration(milliseconds: 300));
      _emailController.clear();
    }
  }

  void _removeEmailAddress(int index, bool isSlideDismissed) {
    final removedItem = _emailAddresses[index];

    _emailAddresses.removeAt(index);

    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildItem(removedItem, animation),
      duration: Duration(milliseconds: isSlideDismissed ? 0 : 300),
    );
  }

  Widget _buildItem(String emailAddress, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(animation),
      child: Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) {
          _removeEmailAddress(_emailAddresses.indexOf(emailAddress), true);
        },
        background: Container(
          color: Colors.red,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Row(
            children: [
              Icon(Icons.delete, color: Colors.white),
              Spacer(),
              Icon(Icons.delete, color: Colors.white)
            ],
          ),
        ),
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
              title: Text(emailAddress),
              trailing: IconButton(
                onPressed: () {
                  _removeEmailAddress(
                      _emailAddresses.indexOf(emailAddress), false);
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red[600],
                ),
              )),
        ),
      ),
    );
  }

  void _updateTeamMembers() {
    if (_emailAddresses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No email addresses to add to the team.'),
        ),
      );
    } else {
      setState(() {
        _isLoading = true;
      });

      // Email addresses are valid
      FirebaseFirestore.instance
          .collection("teams")
          .doc(widget.teamId)
          .get()
          .then((value) async {
        List emails = value.data()!["emails"];
        final totalEmails = emails.length + _emailAddresses.length;
        await Purchases.setLogLevel(LogLevel.debug);

        PurchasesConfiguration? configuration;

        if (Platform.isAndroid) {
          // configure for Google Play Store
        } else if (Platform.isIOS) {
          configuration =
              PurchasesConfiguration("appl_iTxQScKUYowxqRYgHvJbUnAAgKm");
        }

        if (configuration != null) {
          await Purchases.configure(configuration);

          List<StoreProduct> productList = await Purchases.getProducts(
              ["thesalesgong_${totalEmails}_person_team_sub"]);

          try {
            CustomerInfo paywallResult =
                await Purchases.purchaseStoreProduct(productList.first);

            // Purchase was made succesfully and entitlements are active
            if (paywallResult.entitlements.active.values.first.isActive) {
              _addEmailAddresstoDB(_emailAddresses);
            } else {
              if (context.mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Purchase failed'),
                ),
              );
            }
          } on PlatformException catch (e) {
            if (context.mounted) {
              setState(() {
                _isLoading = false;
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
      });
    }
  }

  void _addEmailAddresstoDB(List<String> emailAddresses) async {
    var body = {
      "team_ID": widget.teamId,
      "emails": emailAddresses.toString(),
      "team_name": widget.teamName,
    };

    http.Response response = await http.post(
        Uri.parse("${globals.END_POINT}/account/add_teammember"),
        body: body);

    if (response.statusCode == 201) {
      Navigator.of(context).pop();
    } else if (response.statusCode == 409) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email address already exists'),
          ),
        );
      }
    }

    if (context.mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
