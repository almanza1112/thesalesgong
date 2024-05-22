import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:thesalesgong/globals.dart' as globals;

class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmEmailController = TextEditingController();

  final storage = const FlutterSecureStorage();

  bool _isLoading = false;
  String? emailErrorText;

  Future<void> _changeEmail() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      var body = {
        "uid": FirebaseAuth.instance.currentUser!.uid,
        "old_email": FirebaseAuth.instance.currentUser!.email!,
        "new_email": _emailController.text.trim(),
        "team_ID": await storage.read(key: globals.FSS_TEAM_ID),
      };

      try {
        // Make the HTTP POST request to edit the email content
        http.Response response = await http.post(
            Uri.parse("${globals.END_POINT}/account/change_email"),
            body: body);

        // Check the response status
        if (response.statusCode == 201) {
          FirebaseAuth.instance.currentUser!.reload();
          // Email edited successfully
          setState(() {
            _confirmEmailController.clear();
          });

          print(FirebaseAuth.instance.currentUser!.email);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Email edited successfully')),
            );
          }
        } else if (response.statusCode == 409) {
          // Email is already being used. Please try another email
          setState(() {
            emailErrorText =
                "Email is already being used. Please try another email";
          });
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content:
                      Text('There is an unepected error. Please try again.')),
            );
          }
        }
      } catch (e) {
        // Error occurred while making the HTTP request
        // TODO: Handle the error
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _emailController.text = FirebaseAuth.instance.currentUser!.email!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email'),
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
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  const Text(
                    "You will be logged out after changing your email and must log back in with your new email.",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.white,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: Colors.white),
                        errorText: emailErrorText,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.grey,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: const BorderSide(
                              color: Colors.grey), // Color when not focused
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: const BorderSide(
                              color: Colors.white), // Color when focused
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter valid email';
                        }
                        return null;
                      }),
                  const SizedBox(height: 16),
                  TextFormField(
                      controller: _confirmEmailController,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.white,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Confirm New Email',
                        labelStyle: const TextStyle(color: Colors.white),
                        errorText: emailErrorText,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.grey,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: const BorderSide(
                              color: Colors.grey), // Color when not focused
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: const BorderSide(
                              color: Colors.white), // Color when focused
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your new email';
                        }
                        if (value.trim() != _emailController.text.trim()) {
                          return 'Emails do not match';
                        }
                        return null;
                      }),
                  const Spacer(),
                  TextButton(
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: const Color.fromRGBO(34, 197, 94, 1),
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder()),
                    onPressed: _changeEmail,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text("CHANGE EMAIL"),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
