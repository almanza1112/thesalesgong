import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:thesalesgong/data_classes/team_members.dart';
import 'package:http/http.dart' as http;
import 'package:thesalesgong/globals.dart' as globals;

class TeamPage extends StatefulWidget {
  final String? teamId;
  const TeamPage({super.key, this.teamId});
  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  final _formKey = GlobalKey<FormState>();

  final storage = const FlutterSecureStorage();
  final firestore = FirebaseFirestore.instance;
  final loggedInUserEmail = FirebaseAuth.instance.currentUser!.email;

  String? role;
  bool _isDialogLoading = false;
  String? _emailErrorText;

  int totalTeamMembersAllowed = 0;

  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        late bool isInTeam;
        String role = snapshot.data!["role"];
        if(role != globals.FSS_ADMIN){
          isInTeam = snapshot.data!['is_in_team'];
        } else {
          isInTeam = true;
        }
        String teamName = snapshot.data!["team_name"];
        
        return Scaffold(
          appBar: AppBar(
            title:  isInTeam ? Text(teamName) : const Text('Team'),
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
              // Make sure only the admin can add new team members
              if (role == globals.FSS_ADMIN)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.pushNamed(context, '/edit_team_name');
                  },
                ),
            ],
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
              child: isInTeam ? StreamBuilder(
                stream:
                    firestore.collection("teams").doc(widget.teamId).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    Map<String, dynamic> team =
                        snapshot.data!.data() as Map<String, dynamic>;
        
                    List registeredTeamMembers = team["registered_team_members"];
                    List emails = team["emails"];
                    totalTeamMembersAllowed = team["total_team_members_allowed"];
                    String notRegisteredYet = "Not registered yet";
        
                    List<TeamMember> teamMembers = [];
        
                    for (var i = 0; i < emails.length; i++) {
                      String email = emails[i];
                      if (registeredTeamMembers
                          .any((member) => member["email"] == email)) {
                        // Email is registered, add team member details
                        var registeredMember = registeredTeamMembers
                            .firstWhere((member) => member["email"] == email);
                        teamMembers.add(TeamMember(
                          email: email,
                          name: registeredMember["name"],
                          role: registeredMember["role"],
                        ));
                      } else {
                        // Email is not registered, add default details
                        teamMembers.add(TeamMember(
                          email: email,
                          name: notRegisteredYet,
                          role: "team_member",
                        ));
                      }
                    }
        
                    if (totalTeamMembersAllowed != 20) {
                      while (teamMembers.length < totalTeamMembersAllowed) {
                        teamMembers.add(TeamMember(
                          email: "",
                          name: notRegisteredYet,
                          role: "team_member",
                        ));
                      }
                    }
        
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (role == globals.FSS_ADMIN)
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'To add or remove the total amount of members to your team, go to the Subscription menu to modify your subscription to the appropriate number of members',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: teamMembers.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(12),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        teamMembers[index].name == notRegisteredYet
                                            ? Colors.grey[200]
                                            : Colors.blue[100],
                                    //border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: ListTile(
                                      leading: teamMembers[index].role ==
                                              globals.FSS_TEAM_MEMBER
                                          ? const Icon(Icons.people)
                                          : const Icon(Icons.person),
                                      title: Text(teamMembers[index].email),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(teamMembers[index].name,
                                              style: teamMembers[index].name ==
                                                      notRegisteredYet
                                                  ? const TextStyle(
                                                      fontStyle: FontStyle.italic)
                                                  : null),
                                          Text(teamMembers[index].role ==
                                                  globals.FSS_TEAM_MEMBER
                                              ? "Team Member"
                                              : "Admin"),
                                        ],
                                      ),
                                      trailing: role == globals.FSS_ADMIN &&
                                              loggedInUserEmail !=
                                                  teamMembers[index].email
                                          ? IconButton(
                                              onPressed: () {
                                                if (teamMembers[index].email ==
                                                    "") {
                                                  _addEmail();
                                                } else {
                                                  _editEmail(
                                                      oldEmail:
                                                          teamMembers[index].email,
                                                      isRegistered:
                                                          teamMembers[index].name !=
                                                              notRegisteredYet);
                                                }
                                              },
                                              icon: const Icon(Icons.more_vert))
                                          : null),
                                ),
                              );
                            },
                          ),
                        ),
                        if (role == globals.FSS_ADMIN &&
                            totalTeamMembersAllowed == 20)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(16),
                                backgroundColor:
                                    const Color.fromRGBO(34, 197, 94, 1),
                                foregroundColor: Colors.white, // Modern color
                                shape: const StadiumBorder(),
                              ),
                              onPressed: _addEmail,
                              child: const Text("ADD TEAM MEMBER"),
                            ),
                          ),
                      ],
                    );
                  }
                },
              ) : const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "You are not in a team yet. Please ask your admin to add you to the team.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  void _addEmail() {
    _emailController.clear();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Email Address'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            errorText: _emailErrorText,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email address';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isDialogLoading = true;
                          _emailErrorText = null;
                        });
                        var body = {
                          "new_email": _emailController.text,
                          "team_ID": widget.teamId,
                        };

                        http.Response response = await http.post(
                            Uri.parse(
                                "${globals.END_POINT}/account/admin/add_email"),
                            body: body);

                        if (response.statusCode == 201) {
                          setState(() {
                            _isDialogLoading = false;
                          });

                          if (context.mounted) {
                            Navigator.of(context).pop(); // Close the dialog
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Email address added'),
                              ),
                            );
                          }
                        } else if (response.statusCode == 409) {
                          setState(() {
                            _isDialogLoading = false;
                            _emailErrorText = "Email address already exists";
                          });
                        } else if (response.statusCode == 500) {
                          setState(() {
                            _isDialogLoading = false;
                          });

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'There was an error updating the email address. Please try again.'),
                              ),
                            );
                          }
                        } // Close the dialog
                      }
                    },
                    child: const Text('ADD'),
                  ),
                ],
              ),
            );
          });
        });
  }

  void _editEmail(
      {required String oldEmail, required bool isRegistered}) async {
    _emailController.text = oldEmail;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Edit Email Address'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: 'Email Address', errorText: _emailErrorText),
                ),
                const SizedBox(height: 16),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _deleteDialog(email: oldEmail, isRegistered: isRegistered);
                },
                child:
                    const Text('DELETE', style: TextStyle(color: Colors.red)),
              ),
              TextButton(
                onPressed: () async {
                  setState(() {
                    _isDialogLoading = true;
                    _emailErrorText = null;
                  });
                  var body = {
                    "old_email": oldEmail,
                    "new_email": _emailController.text,
                    "team_ID": widget.teamId,
                  };

                  http.Response response = await http.post(
                      Uri.parse(
                          "${globals.END_POINT}/account/admin/edit_email"),
                      body: body);

                  if (response.statusCode == 201) {
                    setState(() {
                      _isDialogLoading = false;
                    });

                    if (!context.mounted) return;
                    Navigator.of(context).pop(); // Close the dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Email address updated'),
                      ),
                    );
                  } else if (response.statusCode == 409) {
                    setState(() {
                      _isDialogLoading = false;
                      _emailErrorText = "Email address already exists";
                    });
                  } else if (response.statusCode == 500) {
                    setState(() {
                      _isDialogLoading = false;
                    });
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'There was an error updating the email address. Please try again.'),
                      ),
                    );
                  }
                },
                child: _isDialogLoading
                    ? const CircularProgressIndicator()
                    : const Text('UPDATE'),
              ),
            ],
          );
        });
      },
    );
  }

  void _deleteDialog({required String email, required bool isRegistered}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Email Address'),
            content: const Text(
                'Are you sure you want to delete this email address?'),
            actions: [
              TextButton(
                onPressed: () async {
                  var body = {
                    "email": _emailController.text,
                    "team_ID": widget.teamId,
                    "is_registered": isRegistered.toString(),
                  };

                  http.Response response = await http.post(
                      Uri.parse(
                          "${globals.END_POINT}/account/admin/delete_email"),
                      body: body);

                  if (response.statusCode == 201) {
                    if (!context.mounted) return;
                    Navigator.of(context).pop(); // Close the dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Email address deleted'),
                      ),
                    );
                  } else {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'There was an error deleting the email address. Please try again.'),
                      ),
                    );
                  }
                },
                child: const Text('DELETE'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('CANCEL'),
              ),
            ],
          );
        });
  }

  void _addEmailAddress(String emailAddress) async {
    if (emailAddress.isNotEmpty) {
      var body = {
        "team_ID": widget.teamId,
        "email": emailAddress,
        //"team_name": teamName,
      };

      http.Response response = await http.post(
          Uri.parse("${globals.END_POINT}/account/add_teammember"),
          body: body);

      if (response.statusCode == 201) {
      } else if (response.statusCode == 409) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email address already exists'),
            ),
          );
        }
      }
    }
  }
}
