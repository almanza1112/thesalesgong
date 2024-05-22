import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:thesalesgong/globals.dart' as globals;

class EditTeamNamePage extends StatefulWidget {
  const EditTeamNamePage({super.key});
  @override
  State<EditTeamNamePage> createState() => _EditTeamNamePageState();
}

class _EditTeamNamePageState extends State<EditTeamNamePage> {
  final TextEditingController _teamNameController = TextEditingController();
  String? _teamNameErrorText;

  String? team_ID;
  final storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeTeamName();
  }

  Future<void> _initializeTeamName() async {
    _teamNameController.text =
        await storage.read(key: globals.FSS_TEAM_NAME) ?? "Team";
    team_ID = await storage.read(key: globals.FSS_TEAM_ID);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Team Name"),
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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 24),
                  TextFormField(
                      controller: _teamNameController,
                      textCapitalization: TextCapitalization.words,
                      cursorColor: Colors.white,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Team Name',
                        labelStyle: const TextStyle(color: Colors.white),
                        errorText: _teamNameErrorText,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.grey,
                        ),
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
                          return 'Team name cannot be empty';
                        }
                        return null;
                      }),
                  const Spacer(),
                  TextButton(
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: const Color.fromRGBO(34, 197, 94, 1),
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder()),
                    onPressed: _changeTeamName,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text("CHANGE EMAIL"),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _changeTeamName() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final db = FirebaseFirestore.instance;
      db.collection('teams').doc(team_ID).update({
        'team_name': _teamNameController.text,
      }).then((value) async {
        // Team Name was updated
        await storage.write(
            key: globals.FSS_TEAM_NAME, value: _teamNameController.text);
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Team name updated successfully.'),
          ),
        );
      }).catchError((error) {
        // An error occurred
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'An error occurred while updating team name. Please try again.'),
          ),
        );
      });
    }
  }
}
