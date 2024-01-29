import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);
  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final firestore = FirebaseFirestore.instance;

  Future<void> _refreshNotifications() async {
    // Add your logic to fetch data from Firestore here
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
          future: firestore.collection("teams").doc("M1DQ8Q").get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
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
