import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:thesalesgong/globals.dart' as globals;

class AdminSignupPage extends StatefulWidget {
  const AdminSignupPage({Key? key}) : super(key: key);

  @override
  State<AdminSignupPage> createState() => _AdminSignupPageState();
}

class _AdminSignupPageState extends State<AdminSignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final double formPadding = 24;
  String? _emailErrorText = null;

  bool isPasswordObscure = true;
  bool isConfirmPasswordObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Admin Signup'),
        backgroundColor: Colors.white10,
        foregroundColor: Colors.grey[600],
        elevation: 0,
      ),
      body: SafeArea(
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
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      errorText: _emailErrorText,
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
                const Spacer(),
                TextButton(
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder()),
                  onPressed: createAccount,
                  child: const Text("CREATE ACCOUNT"),
                ),
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
    });
    if (_formKey.currentState!.validate()) {
      var body = {
        "name": _nameController.text.trim(),
        "email": _emailController.text.trim(),
        "password": _passwordController.text,
      };

      http.Response response = await http
          .post(Uri.parse("${globals.END_POINT}/sign_up/admin"), body: body);

      if (response.statusCode == 201) {
        // Successully created new user
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['result'] == 'success' && context.mounted) {
          // Sign into Firebase and then navigate to add team members page
          try {
            FirebaseAuth.instance
                .signInWithEmailAndPassword(
                    email: _emailController.text.trim(),
                    password: _passwordController.text)
                .then((value) =>
                    Navigator.pushNamed(context, '/add_team_members'));
          } on FirebaseAuthException catch (e) {
            if (e.code == 'user-not-found') {
              print('No user found for that email.');
            } else if (e.code == 'wrong-password') {
              print('Wrong password provided for that user.');
            }
          }
        }
      } else if (response.statusCode == 409) {
        // errorInfo.code : "auth/email-already-exists" <-- this is from server
        // Error creating new user: The email address is already in use by another account.
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['result'] == 'failure') {
          setState(() {
            _emailErrorText = "Email is already in use";
          });
        }
      } else {
        // Error creating new user
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Error creating new user")));
        }
      }
    }
  }
}
