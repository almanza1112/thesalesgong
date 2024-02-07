import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;
import 'package:thesalesgong/globals.dart' as globals;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();
  final storage = const FlutterSecureStorage();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (await storage.read(key: globals.FSS_NEW_ACCOUNT) == "true" &&
          context.mounted) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Welcome to The Sales Gong'),
                content: const Text(
                    'When you close a deal you are proud of, simply enter a message in the message box and HIT THE SALES GONG. Your team members will receive an alert and you can celebrate together, no matter where you are.\n\nGo get’em!'),
                actions: [
                  TextButton(
                    onPressed: () async {
                      await storage.write(
                          key: globals.FSS_NEW_ACCOUNT, value: "false");
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            });
      }
    });

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
          child: Form(
            key: _formKey,
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
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                      hintText: 'Enter your message here',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Message cannot be empty';
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                  ),
                  onPressed: hitTheSalesGong,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('HIT THE SALES GONG!'),
                ),
              ],
            ),
          ),
        ));
  }

  void hitTheSalesGong() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      String teamID = await storage.read(key: globals.FSS_TEAM_ID) ?? "";
      var body = {
        "message": _messageController.text,
        "user": FirebaseAuth.instance.currentUser!.uid,
        "name": FirebaseAuth.instance.currentUser!.displayName!,
        "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
        "team_ID": teamID
      };

      http.Response response = await http
          .post(Uri.parse("${globals.END_POINT}/gong/hit"), body: body);

      if (response.statusCode == 201) {
        setState(() {
          _isLoading = false;
        });
        _messageController.clear();
        if (context.mounted) {
          Navigator.pushNamed(context, '/notifications');
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to hit the Sales Gong'),
            ),
          );
        }
      }
      if (context.mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
          onTap: () async {
            String? teamID = await storage.read(key: globals.FSS_TEAM_ID);
            if (context.mounted) {
              Navigator.pushNamed(context, '/team', arguments: teamID);
            }
          },
        ),
        ListTile(
          title: const Text('Notifications'),
          onTap: () {
            Navigator.pushNamed(context, '/notifications_settings');
          },
        ),
        ListTile(
          title: const Text('Name'),
          onTap: () {
            Navigator.pushNamed(context, '/name');
          },
        ),
        ListTile(
          title: const Text('Email'),
          onTap: () {
            Navigator.pushNamed(context, '/email');
          },
        ),
        ListTile(
          title: const Text('Password'),
          onTap: () {
            Navigator.pushNamed(context, '/password');
          },
        ),
        ListTile(
          title: const Text('Logout'),
          onTap: logout,
        ),
      ],
    ));
  }

  void logout() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  await const FlutterSecureStorage().deleteAll();
                  if (context.mounted) {
                    Navigator.pushNamed(context, '/opening');
                  }
                },
                child: const Text('LOGOUT'),
              ),
            ],
          );
        });
  }
}
