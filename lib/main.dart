import 'package:flutter/material.dart';
import 'package:thesalesgong/login/admin_signup/add_team_members_page.dart';
import 'package:thesalesgong/login/admin_signup/admin_payment_page.dart';
import 'package:thesalesgong/login/admin_signup/admin_signup_page.dart';
import 'package:thesalesgong/login/login_page.dart';
import 'package:thesalesgong/login/opening_page.dart';
import 'package:thesalesgong/login/signup_page.dart';
import 'package:thesalesgong/login/team_member_signup_page.dart';


void main() async {
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const OpeningPage(),
      routes: {
        '/opening': (context) => const OpeningPage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/admin_signup': (context) => const AdminSignupPage(),
        '/team_member_signup': (context) => const TeamMemberSignupPage(),
        '/add_team_members': (context) => const AddTeamMembersPage(),
        '/admin_payment': (context) => const AdminPaymentPage(),
      },
    );
  }
}
