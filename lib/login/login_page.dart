import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:thesalesgong/globals.dart' as globals;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
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
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
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
              const SizedBox(height: 16),
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
              const Spacer(),
              TextButton(
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: Colors.blue,
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

          // store the user's team_ID in FlutterSecureStorage
          await storage.write(
              key: globals.FSS_TEAM_ID, value: documentSnapshot.get('team_ID'));

          // store the gong tone
          await storage.write(
              key: globals.FSS_GONG_TONE,
              value: documentSnapshot.get('notification_sound'));
          await storage.write(
              key: globals.FSS_ALLOW_GONG_ALERTS, value: 'Always');

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
