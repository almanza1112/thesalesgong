import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:thesalesgong/globals.dart' as globals;

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});
  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  final storage = const FlutterSecureStorage();

  String selectedGongTone = '';
  String allowGongAlerts = '';
  final sectionTitleStyle = TextStyle(
      fontSize: 14, color: Colors.grey[400], fontWeight: FontWeight.bold);
  final gongTextStyle = const TextStyle(color: Colors.white);

  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _iniitializeSettings();
  }

  void _iniitializeSettings() async {
    selectedGongTone = await storage.read(key: globals.FSS_GONG_TONE) ?? '1';
    allowGongAlerts =
        await storage.read(key: globals.FSS_ALLOW_GONG_ALERTS) ?? 'Always';

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
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
        child: Column(
          children: [
            // Gong tone section
            ListTile(
              title: Text(
                'GONG TONE',
                style: sectionTitleStyle,
              ),
            ),
            RadioListTile<String>(
              activeColor: Colors.white,
              title: Text('Gong Tone 1', style: gongTextStyle),
              value: '1',
              groupValue: selectedGongTone,
              onChanged: (value) => updateGong(value),
              
            ),
            RadioListTile<String>(
              activeColor: Colors.white,
              title: Text('Gong Tone 2', style: gongTextStyle),
              value: '2',
              groupValue: selectedGongTone,
              onChanged: (value) => updateGong(value),
            ),
            RadioListTile<String>(
              activeColor: Colors.white,
              title: Text('Gong Tone 3', style: gongTextStyle),
              value: '3',
              groupValue: selectedGongTone,
              onChanged: (value) => updateGong(value),
            ),
            //const SizedBox(height: 24),
            //_allowGoneAlerts()
          ],
        ),
      ),
    );
  }

  Widget _allowGoneAlerts() {
    return Column(
      children: [
        // Allow Gong Alerts section
        ListTile(
          title: Text('ALLOW GONG ALERTS', style: sectionTitleStyle),
        ),
        RadioListTile<String>(
          activeColor: Colors.white,
          title: Text('Always', style: gongTextStyle),
          value: 'Always',
          groupValue: allowGongAlerts,
          onChanged: (value) async {
            await storage.write(
                key: globals.FSS_ALLOW_GONG_ALERTS, value: value!);
            setState(() {
              allowGongAlerts = value;
            });
          },
        ),
        RadioListTile<String>(
          activeColor: Colors.white,
          title: Text('Business Hours', style: gongTextStyle),
          value: 'Business Hours',
          groupValue: allowGongAlerts,
          onChanged: (value) async {
            await storage.write(
                key: globals.FSS_ALLOW_GONG_ALERTS, value: value!);
            setState(() {
              allowGongAlerts = value;
            });
          },
        ),
        RadioListTile<String>(
          activeColor: Colors.white,
          title: Text('Custom', style: gongTextStyle),
          value: 'Custom',
          groupValue: allowGongAlerts,
          secondary: TextButton(
            onPressed: () {
              if (allowGongAlerts == 'Custom') {
                Navigator.pushNamed(context, '/custom_alert_times');
              }
            },
            child: Text(
              'EDIT TIMES',
              style: TextStyle(
                  color: allowGongAlerts == 'Custom'
                      ? const Color.fromRGBO(34, 197, 94, 1)
                      : Colors.grey),
            ),
          ),
          onChanged: (value) async {
            await storage.write(
                key: globals.FSS_ALLOW_GONG_ALERTS, value: value!);

            if (await storage.read(key: globals.FSS_MONDAY_STARTTIME_HOUR) ==
                null) {
              // User has not set custom times yet
              // Proceed to set custom times, 9:00 AM - 5:00 PM
              await storage.write(
                  key: globals.FSS_MONDAY_STARTTIME_HOUR, value: '09');
              await storage.write(
                  key: globals.FSS_MONDAY_STARTTIME_MINUTE, value: '00');
              await storage.write(
                  key: globals.FSS_MONDAY_ENDTIME_HOUR, value: '17');
              await storage.write(
                  key: globals.FSS_MONDAY_ENDTIME_MINUTE, value: '00');
              await storage.write(
                  key: globals.FSS_TUESDAY_STARTTIME_HOUR, value: '09');
              await storage.write(
                  key: globals.FSS_TUESDAY_STARTTIME_MINUTE, value: '00');
              await storage.write(
                  key: globals.FSS_TUESDAY_ENDTIME_HOUR, value: '17');
              await storage.write(
                  key: globals.FSS_TUESDAY_ENDTIME_MINUTE, value: '00');
              await storage.write(
                  key: globals.FSS_WEDNESDAY_STARTTIME_HOUR, value: '09');
              await storage.write(
                  key: globals.FSS_WEDNESDAY_STARTTIME_MINUTE, value: '00');
              await storage.write(
                  key: globals.FSS_WEDNESDAY_ENDTIME_HOUR, value: '17');
              await storage.write(
                  key: globals.FSS_WEDNESDAY_ENDTIME_MINUTE, value: '00');
              await storage.write(
                  key: globals.FSS_THURSDAY_STARTTIME_HOUR, value: '09');
              await storage.write(
                  key: globals.FSS_THURSDAY_STARTTIME_MINUTE, value: '00');
              await storage.write(
                  key: globals.FSS_THURSDAY_ENDTIME_HOUR, value: '17');
              await storage.write(
                  key: globals.FSS_THURSDAY_ENDTIME_MINUTE, value: '00');
              await storage.write(
                  key: globals.FSS_FRIDAY_STARTTIME_HOUR, value: '09');
              await storage.write(
                  key: globals.FSS_FRIDAY_STARTTIME_MINUTE, value: '00');
              await storage.write(
                  key: globals.FSS_FRIDAY_ENDTIME_HOUR, value: '17');
              await storage.write(
                  key: globals.FSS_FRIDAY_ENDTIME_MINUTE, value: '00');
              await storage.write(
                  key: globals.FSS_SATURDAY_STARTTIME_HOUR, value: '09');
              await storage.write(
                  key: globals.FSS_SATURDAY_STARTTIME_MINUTE, value: '00');
              await storage.write(
                  key: globals.FSS_SATURDAY_ENDTIME_HOUR, value: '17');
              await storage.write(
                  key: globals.FSS_SATURDAY_ENDTIME_MINUTE, value: '00');
              await storage.write(
                  key: globals.FSS_SUNDAY_STARTTIME_HOUR, value: '09');
              await storage.write(
                  key: globals.FSS_SUNDAY_STARTTIME_MINUTE, value: '00');
              await storage.write(
                  key: globals.FSS_SUNDAY_ENDTIME_HOUR, value: '17');
              await storage.write(
                  key: globals.FSS_SUNDAY_ENDTIME_MINUTE, value: '00');
            }
            setState(() {
              allowGongAlerts = value;
            });
          },
        ),
      ],
    );
  }

  void updateGong(var value) async {
    await player.play(AssetSource('sounds/gong$value.wav'));
    await storage.write(key: globals.FSS_GONG_TONE, value: value!);

    setState(() {
      selectedGongTone = value;
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'notification_sound': value}).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gong tone updated'),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error updating gong tone'),
        ),
      );
    });
  }
}
