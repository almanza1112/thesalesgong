import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:thesalesgong/globals.dart' as globals;

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({Key? key}) : super(key: key);
  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  final storage = const FlutterSecureStorage();

  String selectedGongTone = '';
  String allowGongAlerts = '';
  final sectionTitleStyle = TextStyle(
      fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.bold);

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
        backgroundColor: Colors.white10,
        foregroundColor: Colors.grey[600],
        shadowColor: Colors.transparent,
      ),
      body: Column(
        children: [
          // Gong tone section
          ListTile(
            title: Text(
              'GONG TONE',
              style: sectionTitleStyle,
            ),
          ),
          RadioListTile<String>(
            title: const Text('Gong Tone 1'),
            value: '1',
            groupValue: selectedGongTone,
            onChanged: (value) async {
              await player.play(AssetSource('sounds/gong_tone_1.mp3'));
              await storage.write(key: globals.FSS_GONG_TONE, value: value!);

              setState(() {
                selectedGongTone = value;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('Gong Tone 2'),
            value: '2',
            groupValue: selectedGongTone,
            onChanged: (value) async {
              await player.play(AssetSource('sounds/gong_tone_2.wav'));
              await storage.write(key: globals.FSS_GONG_TONE, value: value!);

              setState(() {
                selectedGongTone = value;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('Gong Tone 3'),
            value: '3',
            groupValue: selectedGongTone,
            onChanged: (value) async {
              await player.play(AssetSource('sounds/gong_tone_3.wav'));
              await storage.write(key: globals.FSS_GONG_TONE, value: value!);

              setState(() {
                selectedGongTone = value;
              });
            },
          ),
          const SizedBox(height: 24),
          // Allow Gong Alerts section
          ListTile(
            title: Text('ALLOW GONG ALERTS', style: sectionTitleStyle),
          ),
          RadioListTile<String>(
            title: const Text('Always'),
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
            title: const Text('Business Hours'),
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
            title: const Text('Custom'),
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
                        ? Colors.blue
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
      ),
    );
  }
}
