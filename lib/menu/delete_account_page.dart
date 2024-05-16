import 'package:flutter/material.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});
  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Delete Account'),
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
          child: Column(),
        )
      ),
    );
  }
}