import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:thesalesgong/globals.dart' as globals;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isPasswordObscure = true;

  String? _emailErrorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                TextFormField(
                  controller: _emailController,
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
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: isPasswordObscure,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Colors.white),
                    focusColor: const Color.fromRGBO(34, 197, 94, 1),
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
                const Spacer(),
                TextButton(
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: const Color.fromRGBO(34, 197, 94, 1),
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.blue),
                      shape: const StadiumBorder()),
                  onPressed: login,
                  child: const Text('LOGIN'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    // Get fcm_token for push notiifcations
    final firebaseMessage = FirebaseMessaging.instance;
    await firebaseMessage.requestPermission();
    final fcmToken = await firebaseMessage.getToken();

    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      // Need to retrieve the team_id from firestore
      FirebaseFirestore.instance
          .collection('users')
          .doc(value.user!.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
          // User document exists, save team_ID to FlutterSecureStorage
          const storage = FlutterSecureStorage();

          // TODO: need to store the team name as well

          // store the user's team_ID in FlutterSecureStorage
          await storage.write(
              key: globals.FSS_TEAM_ID, value: documentSnapshot.get('team_ID'));

          // store the gong tone
          await storage.write(
              key: globals.FSS_GONG_TONE,
              value: documentSnapshot.get('notification_sound'));

          await storage.write(
              key: globals.FSS_ALLOW_GONG_ALERTS, value: 'Always');

          // store the users role 
          await storage.write(
              key: globals.FSS_ROLE, value: documentSnapshot.get('role'));

          if (context.mounted) {
            // Update the fcm_token in firestore
            FirebaseFirestore.instance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .update({'fcm_token': fcmToken}).then((v) {
              // success, sign in
              Navigator.of(context).pushReplacementNamed('/home');
            });
          }
        } else {
          setState(() {
            // TODO: Change this to a more user-friendly message
            _emailErrorText = 'User does not exist';
          });
        }
      });
    }).catchError((error) {
      setState(() {
        _emailErrorText = error.message;
      });
    });
  }
}
