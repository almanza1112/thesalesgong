import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  TextStyle get _changeSubscriptionOptionsStyle =>
      const TextStyle(color: Colors.white, fontSize: 16);

  TextStyle get _labelTextStyle =>
      const TextStyle(color: Colors.white, fontSize: 14);

  TextStyle get _resultTextStyle =>
      const TextStyle(color: Colors.white, fontSize: 16);

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
                        Row(
                          children: [
                            Text(
                              'Subscription Status:',
                              style: _labelTextStyle,
                            ),
                            const Spacer(),
                            Text(
                              data['subscription']["status"].toUpperCase(),
                              style: _resultTextStyle,
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'Subscription Type',
                              style: _labelTextStyle,
                            ),
                            const Spacer(),
                            Text(
                              data['subscription']
                                          ['total_team_members_allowed'] <
                                      20
                                  ? "${data['subscription']['total_team_members_allowed']} Person Team Subscription"
                                  : "Unlimited Team Subscription",
                              style: _resultTextStyle,
                            )
                          ],
                        ),
                        const Spacer(),
                        TextButton(
                          style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                              backgroundColor:
                                  const Color.fromRGBO(34, 197, 94, 1),
                              foregroundColor: Colors.white,
                              shape: const StadiumBorder()),
                          onPressed: _changeSubscription,
                          child: const Text("CHANGE SUBSCRIPTION"),
                        ),
                        const SizedBox(height: 8),
                      ],
                    );
                  }))),
        ),
      ),
    );
  }

  void _changeSubscription() async {
    Navigator.pushNamed(context, '/change_subscription');
  }
}
