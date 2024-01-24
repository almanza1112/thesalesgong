import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:thesalesgong/globals.dart' as globals;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('The Sales Gong'),
          backgroundColor: Colors.white10,
          foregroundColor: Colors.grey[600],
          shadowColor: Colors.transparent,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/notifications');
              },
              icon: const Icon(Icons.notifications),
            ),
          ],
        ),
        drawer: menu(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/images/gong.png',
                height: 200,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _messageController,
                decoration: InputDecoration(
                    hintText: 'Enter your message here',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40))),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the name on card';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: const StadiumBorder(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                onPressed: hitTheSalesGong,
                child: const Text('HIT THE SALES GONG!'),
              ),
            ],
          ),
        ));
  }

  void hitTheSalesGong() async {
    print("im hitting the sales gong");
    var body ={
      "message": _messageController.text,
      "user": FirebaseAuth.instance.currentUser!.uid,
    };

    http.Response response = await http
        .post(Uri.parse("${globals.END_POINT}/gong/hit"), body: body);
  }

  Widget menu() {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
         UserAccountsDrawerHeader(
          accountName: Text(FirebaseAuth.instance.currentUser!.displayName!),
          accountEmail: Text(FirebaseAuth.instance.currentUser!.email!),
          decoration: const BoxDecoration(
            color: Colors.blue,
          ),
        ),
        ListTile(
          title: const Text('Team'),
          onTap: () {
            Navigator.pushNamed(context, '/team');
          },
        ),
        ListTile(
          title: const Text('Notifications'),
          onTap: () {
            Navigator.pushNamed(context, '/notifications_settings');
          },
        ),
        ListTile(
          title: const Text('Email'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text('Password'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text('Logout'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    ));
  }
}
