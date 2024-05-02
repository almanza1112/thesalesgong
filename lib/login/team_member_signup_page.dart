import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:thesalesgong/globals.dart' as globals;

class TeamMemberSignupPage extends StatefulWidget {
  const TeamMemberSignupPage({super.key});
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

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, //TODO: Look into this
      appBar: AppBar(
        title: const Text('Team Member Signup'),
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
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: SafeArea(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: formPadding),
                        TextFormField(
                          controller: _nameController,
                          textCapitalization: TextCapitalization.words,
                          cursorColor: Colors.white,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Name',
                            labelStyle: const TextStyle(color: Colors.white),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            prefixIcon: const Icon(
                              Icons.person,
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
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: formPadding),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Colors.white,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: const TextStyle(color: Colors.white),
                            errorText: _emailErrorText,
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
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: formPadding),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: isPasswordObscure,
                          cursorColor: Colors.white,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(color: Colors.white),
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
                              return 'Please enter a password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: formPadding),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: isConfirmPasswordObscure,
                          cursorColor: Colors.white,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Confrim Password',
                            labelStyle: const TextStyle(color: Colors.white),
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
                          cursorColor: Colors.white,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Team ID',
                            labelStyle: const TextStyle(color: Colors.white),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            errorText: _teamIDErrorText,
                            prefixIcon: const Icon(
                              Icons.group,
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
                              return 'Please enter your team ID';
                            }
                            return null;
                          },
                        ),
                        const Spacer(),
                        TextButton(
                          style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                              backgroundColor:
                                  const Color.fromRGBO(34, 197, 94, 1),
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.blue),
                              shape: const StadiumBorder()),
                          onPressed: createAccount,
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : const Text('SIGN UP'),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
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
      setState(() {
        _isLoading = true;
      });
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
        Map<String, dynamic> data = jsonDecode(response.body);
        try {
          FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: _emailController.text.trim(),
                  password: _passwordController.text)
              .then((value) async {
            const storage = FlutterSecureStorage();

            await storage.write(
                key: globals.FSS_TEAM_ID, value: _teamIdController.text);

            await storage.write(key: globals.FSS_NEW_ACCOUNT, value: 'true');

            await storage.write(
                key: globals.FSS_TEAM_NAME, value: data['team_name']);

            await storage.write(
                key: globals.FSS_ROLE, value: globals.FSS_TEAM_MEMBER);
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

      if (context.mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
