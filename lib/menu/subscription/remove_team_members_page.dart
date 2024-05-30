import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RemoveTeamMembersPage extends StatefulWidget {
  final Function(List<String>, int) onListUpdated;
  final String teamID;
  final int totalNewMembers;

  const RemoveTeamMembersPage(
      {required this.onListUpdated, required this.teamID, required this.totalNewMembers, super.key});

  @override
  State<RemoveTeamMembersPage> createState() => _RemoveTeamMembersPageState();
}

class _RemoveTeamMembersPageState extends State<RemoveTeamMembersPage> {
  final ValueNotifier<List<String>> _selectedEmailsNotifier =
      ValueNotifier<List<String>>([]);

  String get teamID => widget.teamID;

  void _toggleSelection(String email) {
    _selectedEmailsNotifier.value =
        List.from(_selectedEmailsNotifier.value); // Create a copy of the list
    if (_selectedEmailsNotifier.value.contains(email)) {
      _selectedEmailsNotifier.value.remove(email);
    } else {
      _selectedEmailsNotifier.value.add(email);
    }
  }  

  @override
  void dispose() {
    _selectedEmailsNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remove Team Members'),
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
          child: FutureBuilder(
            future:
                FirebaseFirestore.instance.collection('teams').doc(teamID).get(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final teamData = snapshot.data!.data() as Map<String, dynamic>;
              final teamMembers = teamData['emails'] as List<dynamic>;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: teamMembers.length,
                      itemBuilder: (context, index) {
                        final email = teamMembers[index] as String;
                        return ValueListenableBuilder<List<String>>(
                          valueListenable: _selectedEmailsNotifier,
                          builder: (context, selectedEmails, _) {
                            return CheckboxListTile(
                              title: Text(
                                email,
                                style: const TextStyle(color: Colors.white),
                              ),
                              value: selectedEmails.contains(email),
                              onChanged: (bool? selected) {
                                _toggleSelection(email);
                              },
                              activeColor:
                                  Colors.red, // Customize the checkbox color
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextButton(
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: const StadiumBorder()),
                      onPressed: () => _validate(teamMembers.length),
                      child: const Text("REMOVE"),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // Method to validate that the user has selected the correct amount of members to remove so that it is equal (or less than) to the totalNewMembers
  void _validate(int teamMembers) {

    if (teamMembers - _selectedEmailsNotifier.value.length > widget.totalNewMembers) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(
                'You must remove at least ${(teamMembers - _selectedEmailsNotifier.value.length) - widget.totalNewMembers} more member(s) to proceed.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              )
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Confirm'),
            content: const Text(
                "Are you sure you want to remove the selected members?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('NO'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _removeSelectedMembers();
                },
                child: const Text('YES'),
              )
            ],
          );
        },
      );
    }
  }

  void _removeSelectedMembers() {
    widget.onListUpdated(_selectedEmailsNotifier.value, widget.totalNewMembers);
    Navigator.pop(context);
  }
}
