import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:thesalesgong/globals.dart' as globals;

class TeamMemberSignupPage extends StatefulWidget {
  const TeamMemberSignupPage({Key? key}) : super(key: key);
  @override
  State<TeamMemberSignupPage> createState() => _TeamMemberSignupPageState();
}

class _TeamMemberSignupPageState extends State<TeamMemberSignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _teamIdController = TextEditingController();
  final double formPadding = 24;

  bool isPasswordObscure = true;
  bool isConfirmPasswordObscure = true;

  String? _teamIDErrorText;
  String? _emailErrorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, //TODO: Look into this
      appBar: AppBar(
        title: const Text('Team Member Signup'),
        backgroundColor: Colors.white10,
        foregroundColor: Colors.grey[600],
        shadowColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: formPadding),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      labelText: 'Name',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: formPadding),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      labelText: 'Email',
                      errorText: _emailErrorText,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: formPadding),
                TextFormField(
                  controller: _passwordController,
                  obscureText: isPasswordObscure,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.grey,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isPasswordObscure = !isPasswordObscure;
                          });
                        },
                        icon: Icon(isPasswordObscure
                            ? Icons.visibility
                            : Icons.visibility_off),
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: formPadding),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: isConfirmPasswordObscure,
                  decoration: InputDecoration(
                      labelText: 'Confrim Password',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.grey,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isConfirmPasswordObscure =
                                !isConfirmPasswordObscure;
                          });
                        },
                        icon: Icon(isConfirmPasswordObscure
                            ? Icons.visibility
                            : Icons.visibility_off),
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: formPadding),
                TextFormField(
                  controller: _teamIdController,
                  decoration: InputDecoration(
                      labelText: 'Team ID',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      errorText: _teamIDErrorText,
                      prefixIcon: const Icon(
                        Icons.group,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your team ID';
                    }
                    return null;
                  },
                ),
                const Spacer(),
                TextButton(
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.blue),
                      shape: const StadiumBorder()),
                  onPressed: createAccount,
                  child: const Text('SIGN UP'),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void createAccount() async {
    setState(() {
      _emailErrorText = null;
      _teamIDErrorText = null;
    });
    if (_formKey.currentState!.validate()) {
      final firebaseMessage = FirebaseMessaging.instance;
      await firebaseMessage.requestPermission();
      final fcmToken = await firebaseMessage.getToken();
      var body = {
        "name": _nameController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
        "team_ID": _teamIdController.text,
        "fcm_token": fcmToken,
      };

      http.Response response = await http.post(
          Uri.parse("${globals.END_POINT}/sign_up/team_member"),
          body: body);

      if (response.statusCode == 201 && context.mounted) {
        // Success
        // Sign into Firebase
        try {
          FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: _emailController.text.trim(),
                  password: _passwordController.text)
              .then((value) async {
            final storage = FlutterSecureStorage();
            await storage.write(
                key: globals.FSS_TEAM_ID, value: _teamIdController.text);
            if (context.mounted) {
              Navigator.pushNamed(context, '/home');
            }
          });
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            print('No user found for that email.');
          } else if (e.code == 'wrong-password') {
            print('Wrong password provided for that user.');
          }
        }
      } else if (response.statusCode == 409 && context.mounted) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['part'] == 'creating user') {
          setState(() {
            _emailErrorText = 'Email already in use for another account';
          });
        } else if (data['part'] == 'finding team') {
          setState(() {
            _emailErrorText = 'Email does not belong to team';
          });
        }
      } else if (response.statusCode == 500 && context.mounted) {
        // Error 500 = team id not found || user already has account
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['part'] == 'creating user') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error creating new user, please try again later'),
            ),
          );
        } else if (data['part'] == 'finding team') {
          setState(() {
            _teamIDErrorText = 'Team ID not found';
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Server error, please try again later'),
            ),
          );
        }
      }
    }
  }
}
