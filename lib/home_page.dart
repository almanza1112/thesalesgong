import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;
import 'package:thesalesgong/globals.dart' as globals;
import 'package:thesalesgong/menu/team_settings_page.dart';
import 'package:thesalesgong/notifications_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();
  final storage = const FlutterSecureStorage();

  bool _isLoading = false;

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    showDialog(
        context: context,
        builder: (context) {
          String body = message.notification!.body!;
          // Regular expression to match text within double quotes
          RegExp regExp = RegExp(r'"([^"]*)"');
          // Extract message within quotes
          String extractedMessage = regExp.firstMatch(body)!.group(1)!;
          return AlertDialog(
            title: Text(message.notification!.title!),
            content: Text(extractedMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('AWESOME!'),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    setupInteractedMessage();

    super.initState();
  }

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
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotificationsPage(
                              wasGongHit: false,
                            )));
              },
              icon: const Icon(Icons.notifications),
            ),
          ],
        ),
        drawer: menu(),
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
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
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
                          style: const TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            hintText: 'Enter your message here',
                            hintStyle: const TextStyle(color: Colors.grey),
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
                              return 'Message cannot be empty';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(34, 197, 94, 1),
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
                ),
              ),
            ],
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
        "uid": FirebaseAuth.instance.currentUser!.uid,
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
              Map<String, dynamic> data = jsonDecode(response.body);

        print(data);

        final successMessage = data['message'];
        if (context.mounted) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NotificationsPage(
                        wasGongHit: true,
                        successMessage: successMessage,
                      )));
        }
      } else if (response.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No other team members to notify'),
          ),
        );
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
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color.fromRGBO(30, 58, 138, 1),
                  Color.fromRGBO(79, 70, 229, 1)
                ],
              ),
            )),
        ListTile(
          title: const Text('Team'),
          onTap: () async {
            String? teamID = await storage.read(key: globals.FSS_TEAM_ID);
            if (context.mounted) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return TeamPage(
                  teamId: teamID!,
                );
              }));
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
