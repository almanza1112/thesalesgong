import 'package:flutter/material.dart';

class OpeningPage extends StatelessWidget {
  const OpeningPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 50,
            ),
            Text(
              "The Sales Gong",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 36,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'HOW MODERN SALES TEAM CELEBRATE',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(
              height: 40,
            ),
            Image.asset(
              'assets/images/gong.png',
              height: 200,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: TextButton(
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder()),
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text("LOGIN"),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: OutlinedButton(
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    side: const BorderSide(color: Colors.blue),
                    shape: const StadiumBorder()),
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: const Text("SIGN UP"),
              ),
            ),
            const SizedBox(height: 8,)
          ],
        ),
      ),
    );
  }
}
