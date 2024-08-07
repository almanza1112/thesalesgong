import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  final bool? wasGongHit;
  final String? successMessage;
  const NotificationsPage({super.key, this.wasGongHit, this.successMessage});
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
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('An error occurred! Please try again later', style: TextStyle(color: Colors.white, fontSize: 16)),
              );
            }

            final userData = snapshot.data!.data() as Map<String, dynamic>;

            if (userData['is_in_team'] == false) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text('You are not in a team yet. Please ask your admin to add you to the team.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16),),
                ),
              );
            }
            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: _refreshNotifications,
                  child: FutureBuilder<DocumentSnapshot>(
                    future: firestore
                        .collection("teams")
                        .doc(userData['team_ID'])
                        .get(),
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
                            int timestamp =
                                int.parse(notification['timestamp']);
                            return Padding(
                              padding: const EdgeInsets.all(12),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
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
                if (widget.wasGongHit!)
                  SuccessMessageOverlay(
                    successMessage: widget.successMessage!,
                  ),
              ],
            );
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
        '${_addLeadingZero(month)}/${_addLeadingZero(day)}/$year\n ${_addLeadingZero(_getHourIn12HourFormat(hour))}:${_addLeadingZero(minute)} $period';

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

class SuccessMessageOverlay extends StatefulWidget {
  final String successMessage;

  const SuccessMessageOverlay({super.key, required this.successMessage});

  @override
  State<SuccessMessageOverlay> createState() => _SuccessMessageOverlayState();
}

class _SuccessMessageOverlayState extends State<SuccessMessageOverlay> {
  bool _visible = true;
  static const fadeDuration = Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _visible = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _visible,
      child: AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: fadeDuration,
        child: Container(
          color: Colors.white.withOpacity(0.8),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                widget.successMessage,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
