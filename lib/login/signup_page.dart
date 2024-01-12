import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
        backgroundColor: Colors.white10,
        shadowColor: Colors.transparent,
        foregroundColor: Colors.grey[600],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: TextButton(
              style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: const StadiumBorder()),
              onPressed: () {
                Navigator.pushNamed(context, '/admin_signup');
              },
              child: const Text("ADMIN"),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: TextButton(
              style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: const StadiumBorder()),
              onPressed: () {
                Navigator.pushNamed(context, '/team_member_signup');
              },
              child: const Text("TEAM MEMBER"),
            ),
          ),
        ],
      ),
    );
  }
}
