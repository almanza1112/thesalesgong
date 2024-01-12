import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Admin Signup'),
        backgroundColor: Colors.white10,
        foregroundColor: Colors.grey[600],
        shadowColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_team_members');
        },
        child: const Icon(Icons.arrow_forward),
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
                  decoration: InputDecoration(
                      labelText: 'Password',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40))),
                  obscureText: true,
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
                  decoration: InputDecoration(
                      labelText: 'Confrim Password',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: const Icon(
                        Icons.lock,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
