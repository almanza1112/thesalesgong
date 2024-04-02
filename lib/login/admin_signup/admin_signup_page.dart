import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:thesalesgong/data_classes/admin_signing_up.dart';
import 'package:thesalesgong/globals.dart' as globals;
import 'package:thesalesgong/login/admin_signup/add_team_name_page.dart';

class AdminSignupPage extends StatefulWidget {
  const AdminSignupPage({super.key});

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

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Admin Signup'),
        backgroundColor: Colors.white10,
        foregroundColor: Colors.grey[600],
        elevation: 0,
      ),
      body: CustomScrollView(
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
                        autocorrect: true,
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
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: true,
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
                        autocorrect: false,
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
                        autocorrect: false,
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
                        onPressed: _isLoading ? null : createAccount,
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text("CREATE ACCOUNT"),
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
    );
  }

  void createAccount() async {
    setState(() {
      _emailErrorText = null;
    });
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      http.Response response = await http.get(Uri.parse(
          "${globals.END_POINT}/sign_up/email_check?email=${_emailController.text.trim()}"));

      if (response.statusCode == 200) {
        // Successully created new user
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['result'] == 'success') {
          AdminSigningUp adminSigningUp = AdminSigningUp(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            displayName: _nameController.text.trim(),
          );
          if (!mounted) return;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddTeamNamePage(adminSigningUp: adminSigningUp)));
        }
      } else if (response.statusCode == 409) {
        // Email already exists or email is improperly formatted
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['message'] == 'Email exists') {
          setState(() {
            _emailErrorText = "Email is already in use";
          });
        } else if (data['message'] == 'auth/invalid-email') {
          setState(() {
            _emailErrorText = "Email address is improperly formatted";
          });
        }
      } else {
        // Error creating new user
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Error creating new user")));
      }

      setState(() {
        _isLoading = false;
      });
    }
  }
}
