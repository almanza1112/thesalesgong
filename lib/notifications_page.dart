import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);
  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final firestore = FirebaseFirestore.instance;
  final storage = FlutterSecureStorage();
  String teamId = '';

  Future<void> _refreshNotifications() async {
    // Add your logic to fetch data from Firestore here
  }

  @override
  void initState() {
    storage.read(key: 'teamId').then((value) {
      setState(() {
        teamId = value!;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.white10,
        foregroundColor: Colors.grey[600],
        shadowColor: Colors.transparent,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshNotifications,
        child: FutureBuilder<DocumentSnapshot>(
          future: teamId.isNotEmpty
              ? firestore.collection("teams").doc(teamId).get()
              : null,
          builder: (context, snapshot) {
            if (teamId.isEmpty) {
              return const Center(child: Text('Team ID is not available yet.'));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final notifications = snapshot.data!.data() as Map;
              List gongList = notifications["gong_history"];
              return ListView.builder(
                itemCount: gongList.length,
                itemBuilder: (context, index) {
                  final notification = gongList[index];
                  final name = notification['name'];
                  final message = notification['message'];
                  return ListTile(
                    title: Text(name),
                    subtitle: Text(message),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
