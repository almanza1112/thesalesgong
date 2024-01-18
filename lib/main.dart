import 'package:flutter/material.dart';
import 'package:thesalesgong/home_page.dart';
import 'package:thesalesgong/login/admin_signup/add_team_members_page.dart';
import 'package:thesalesgong/login/admin_signup/admin_payment_page.dart';
import 'package:thesalesgong/login/admin_signup/admin_signup_page.dart';
import 'package:thesalesgong/login/login_page.dart';
import 'package:thesalesgong/login/opening_page.dart';
import 'package:thesalesgong/login/signup_page.dart';
import 'package:thesalesgong/login/team_member_signup_page.dart';
import 'package:thesalesgong/menu/notifications_settings_page.dart';
import 'package:thesalesgong/menu/team_settings_page.dart';
import 'package:thesalesgong/notifications_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Sales Gong',
      theme: ThemeData(
        useMaterial3: true
      ),
      home: const OpeningPage(),
      routes: {
        '/opening': (context) => const OpeningPage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/admin_signup': (context) => const AdminSignupPage(),
        '/team_member_signup': (context) => const TeamMemberSignupPage(),
        '/add_team_members': (context) => const AddTeamMembersPage(),
        '/admin_payment': (context) => const AdminPaymentPage(),
        '/home': (context) => const HomePage(),
        '/notifications': (context) => const NotificationsPage(),
        '/team': (context) => const TeamPage(),
        '/notifications_settings': (context) => const NotificationSettingsPage(),
      },
    );
  }
}
