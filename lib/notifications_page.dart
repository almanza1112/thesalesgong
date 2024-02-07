import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:thesalesgong/globals.dart' as globals;  

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
    storage.read(key: globals.FSS_TEAM_ID).then((value) {
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
      body: teamId.isEmpty
          ? const Center(child: Text('Team ID is not available yet.'))
          : RefreshIndicator(
              onRefresh: _refreshNotifications,
              child: FutureBuilder<DocumentSnapshot>(
                future: firestore.collection("teams").doc(teamId).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final notifications = snapshot.data!.data() as Map;
                    List gongList = notifications["gong_history"];

                    // Reverse the list to show the latest notification first
                    gongList = List.from(gongList.reversed);
                    return ListView.builder(
                      itemCount: gongList.length,
                      itemBuilder: (context, index) {
                        final notification = gongList[index];
                        final name = notification['name'];
                        final message = notification['message'];
                        int timestamp = int.parse(notification['timestamp']);
                        return Padding(
                          padding: const EdgeInsets.all(12),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration:  BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey[200],
                            ),
                            child: ListTile(
                              title: Text(name),
                              subtitle: Text(message),
                              leading: Text(_formatDateTime(timestamp)),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
    );
  }

String _formatDateTime(int millisecondsSinceEpoch) {
    // Create a DateTime object from milliseconds since epoch
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);

    // Extract components of the DateTime object
    int month = dateTime.month;
    int day = dateTime.day;
    int year = dateTime.year;
    int hour = dateTime.hour;
    int minute = dateTime.minute;
    String period = (hour >= 12) ? 'PM' : 'AM';

    // Format the date and time components into a string
    String formattedDateTime =
        '${_addLeadingZero(month)}/${_addLeadingZero(day)}/${year}\n ${_addLeadingZero(_getHourIn12HourFormat(hour))}:${_addLeadingZero(minute)} $period';

    return formattedDateTime;
  }

// Helper function to add leading zero to single digit numbers
  String _addLeadingZero(int number) {
    return (number < 10) ? '0$number' : '$number';
  }

// Helper function to convert hour to 12-hour format
  int _getHourIn12HourFormat(int hour) {
    return (hour > 12) ? hour - 12 : hour;
  }
}