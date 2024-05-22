import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  bool _isUpdateLoading = false;
  bool _isDisableLoading = false;

  TextStyle get _textStyle =>
      const TextStyle(color: Colors.white, fontSize: 14);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription'),
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
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .get(),
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final data = snapshot.data as DocumentSnapshot;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 24),
                        Text(
                          'Subscription Status: ${data['subscription']["status"]}',
                          style: _textStyle,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Subscription Type: ${data['subscription']["type"]}',
                          style: _textStyle,
                        ),
                        const Spacer(),
                        TextButton(
                          style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              shape: const StadiumBorder()),
                          onPressed: _disableSubscription,
                          child: _isDisableLoading
                              ? const CircularProgressIndicator()
                              : const Text("DISABLE SUBSCRIPTION"),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                              backgroundColor:
                                  const Color.fromRGBO(34, 197, 94, 1),
                              foregroundColor: Colors.white,
                              shape: const StadiumBorder()),
                          onPressed: _updateSubscription,
                          child: _isUpdateLoading
                              ? const CircularProgressIndicator()
                              : const Text("CHANGE SUBSCRIPTION"),
                        ),
                        const SizedBox(height: 8),
                      ],
                    );
                  }))),
        ),
      ),
    );
  }

  void _updateSubscription() {}

  void _disableSubscription() {}
}
