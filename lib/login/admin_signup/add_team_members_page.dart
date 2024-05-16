import 'package:flutter/material.dart';
import 'package:thesalesgong/data_classes/admin_signing_up.dart';
import 'package:http/http.dart' as http;
import 'package:thesalesgong/globals.dart' as globals;
import 'package:thesalesgong/login/admin_signup/admin_payment_page.dart';

class AddTeamMembersPage extends StatefulWidget {
  final AdminSigningUp? adminSigningUp;

  const AddTeamMembersPage({super.key, this.adminSigningUp});

  @override
  State<AddTeamMembersPage> createState() => _AddTeamMembersPageState();
}

class _AddTeamMembersPageState extends State<AddTeamMembersPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<String> _emailAddresses = [];

  final TextEditingController _emailController = TextEditingController();
  bool _isDialogLoading = false;
  String? _emailErrorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Team Members'),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(34, 197, 94, 1),
        foregroundColor: Colors.white,
        onPressed: validateEmailAddressList,
        child: const Icon(Icons.arrow_forward),
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
        child: AnimatedList(
          key: _listKey,
          initialItemCount: _emailAddresses.length,
          itemBuilder: (context, index, animation) {
            return _buildItem(_emailAddresses[index], animation);
          },
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

  void validateEmailAddressList() {
    if (_emailAddresses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one email address'),
        ),
      );
    } else {
      // Email addresses are valid
      AdminSigningUp adminSigningUp = widget.adminSigningUp!.copyWith(
        teamEmailAddresses: _emailAddresses,
      );

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AdminPaymentPage(adminSigningUp: adminSigningUp)));
    }
  }
}
