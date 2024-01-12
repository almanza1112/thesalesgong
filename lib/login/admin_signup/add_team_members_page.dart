import 'package:flutter/material.dart';

class AddTeamMembersPage extends StatefulWidget {
  const AddTeamMembersPage({Key? key}) : super(key: key);
  @override
  State<AddTeamMembersPage> createState() => _AddTeamMembersPageState();
}

class _AddTeamMembersPageState extends State<AddTeamMembersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Team Members'),
        backgroundColor: Colors.white10,
        foregroundColor: Colors.grey[600],
        shadowColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/admin_payment');
        },
        child: const Icon(Icons.arrow_forward),
      ),
      body: Column(
        children: [
          
        ],
      )
    );
  }
}
