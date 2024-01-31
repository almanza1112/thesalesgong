import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thesalesgong/data_classes/team_members.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({Key? key}) : super(key: key);
  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;

    String teamId = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Team'),
          backgroundColor: Colors.white10,
          foregroundColor: Colors.grey[600],
          shadowColor: Colors.transparent,
        ),
        body: FutureBuilder(
          future: firestore.collection("teams").doc(teamId).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              Map<String, dynamic> team =
                  snapshot.data!.data() as Map<String, dynamic>;
              List registeredTeamMembers = team["registered_team_members"];
              List emails = team["emails"];
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

              return ListView.builder(
                itemCount: teamMembers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: teamMembers[index].name == notRegisteredYet
                            ? Colors.grey[200]
                            : Colors.blue[100],
                        //border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(
                        leading: teamMembers[index].role == "team_member"
                            ? const Icon(Icons.people)
                            : const Icon(Icons.person),
                        title: Text(teamMembers[index].email),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(teamMembers[index].name, style: teamMembers[index].name == notRegisteredYet ? const TextStyle(fontStyle: FontStyle.italic) : null),
                            Text(teamMembers[index].role == "team_member"
                                ? "Team Member"
                                : "Admin"),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ));
  }
}
