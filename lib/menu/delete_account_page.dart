import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:thesalesgong/globals.dart' as globals;

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});
  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final storage = const FlutterSecureStorage();
  bool _isLoading = false;

  String? role;

  @override
  void initState() {
    super.initState();
    _initializeTeamName();
  }

  Future<void> _initializeTeamName() async {
    role = await storage.read(key: globals.FSS_ROLE) ?? globals.FSS_TEAM_MEMBER;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Account'),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 24),
                  Text(
                    role == globals.FSS_ADMIN
                        ? "You are the admin of this team. Once you delete your account, your team will also be deleted and none of the information will be able to be recovered."
                        : "Once your account is deleted, you will lose all your data and you will not be able to recover it.",
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  const Spacer(),
                  TextButton(
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder()),
                    onPressed: _deleteAccount,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text("DELETE ACCOUNT"),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          )),
    );
  }

  void _deleteAccount() async {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text("Confirmation"),
            content:
                const Text("Are you sure you want to delete your account?"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("CANCEL"),
              ),
              TextButton(
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  var body = {};

                  http.Response response = await http.post(
                      Uri.parse("${globals.END_POINT}/account/delete_account"),
                      body: body);

                  if (response.statusCode == 201) {
                    setState(() {
                      _isLoading = false;
                    });
                  } else if (response.statusCode == 400) {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                },
                child: const Text("DELETE"),
              ),
            ],
          );
        });
      },
    );
  }
}
