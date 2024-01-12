import 'package:flutter/material.dart';
import 'package:thesalesgong/login/login_page.dart';


void main() async {
  
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: LoginPage(),
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
