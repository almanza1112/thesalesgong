import 'package:flutter/material.dart';

class AddTeamNamePage extends StatefulWidget {
  const AddTeamNamePage({Key? key}) : super(key: key);

  @override
  State<AddTeamNamePage> createState() => _AddTeamNamePageState();
}

class _AddTeamNamePageState extends State<AddTeamNamePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _teamNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Team Name'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Navigator.pushNamed(context, '/add_team_members', arguments: _teamNameController.text.trim());
          }
        },
        child: const Icon(Icons.arrow_forward),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 24),
                TextFormField(
                  controller: _teamNameController,
                  //keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  autocorrect: true,
                  decoration:  InputDecoration(
                    labelText: 'Team Name',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    prefixIcon: const Icon(
                      Icons.group,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Team name cannot be empty';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        // Add your UI elements here
      ),
    );
  }
}
