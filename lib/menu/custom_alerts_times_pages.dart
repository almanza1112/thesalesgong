import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:thesalesgong/globals.dart' as globals;

class CustomAlertTimesPage extends StatefulWidget {
  const CustomAlertTimesPage({Key? key}) : super(key: key);

  @override
  State<CustomAlertTimesPage> createState() => _CustomAlertTimesPageState();
}

class _CustomAlertTimesPageState extends State<CustomAlertTimesPage> {
  final TextStyle startEndTimeStyle =
      const TextStyle(fontSize: 24, color: Colors.black);

  bool _mondaySwitch = false;
  bool _tuesdaySwitch = false;
  bool _wednesdaySwitch = false;
  bool _thursdaySwitch = false;
  bool _fridaySwitch = false;
  bool _saturdaySwitch = false;
  bool _sundaySwitch = false;

  String _mondayStartHour = '09';
  String _mondayStartMinute = '00';
  String _mondayEndHour = '17';
  String _mondayEndMinute = '00';
  String _tuesdayStartHour = '09';
  String _tuesdayStartMinute = '00';
  String _tuesdayEndHour = '17';
  String _tuesdayEndMinute = '00';
  String _wednesdayStartHour = '09';
  String _wednesdayStartMinute = '00';
  String _wednesdayEndHour = '17';
  String _wednesdayEndMinute = '00';
  String _thursdayStartHour = '09';
  String _thursdayStartMinute = '00';
  String _thursdayEndHour = '17';
  String _thursdayEndMinute = '00';
  String _fridayStartHour = '09';
  String _fridayStartMinute = '00';
  String _fridayEndHour = '17';
  String _fridayEndMinute = '00';
  String _saturdayStartHour = '09';
  String _saturdayStartMinute = '00';
  String _saturdayEndHour = '17';
  String _saturdayEndMinute = '00';
  String _sundayStartHour = '09';
  String _sundayStartMinute = '00';
  String _sundayEndHour = '17';
  String _sundayEndMinute = '00';

  final storage = const FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
    _initializeSettings();
  }

  Future<void> _initializeSettings() async {
    _mondaySwitch =
        await storage.read(key: globals.FSS_MONDAY_SWITCH) == "true";
    _tuesdaySwitch =
        await storage.read(key: globals.FSS_TUESDAY_SWITCH) == "true";
    _wednesdaySwitch =
        await storage.read(key: globals.FSS_WEDNESDAY_SWITCH) == "true";
    _thursdaySwitch =
        await storage.read(key: globals.FSS_THURSDAY_SWITCH) == "true";
    _fridaySwitch =
        await storage.read(key: globals.FSS_FRIDAY_SWITCH) == "true";
    _saturdaySwitch =
        await storage.read(key: globals.FSS_SATURDAY_SWITCH) == "true";
    _sundaySwitch =
        await storage.read(key: globals.FSS_SUNDAY_SWITCH) == "true";

    _mondayStartHour =
        await storage.read(key: globals.FSS_MONDAY_STARTTIME_HOUR) ?? '09';
    _mondayStartMinute =
        await storage.read(key: globals.FSS_MONDAY_STARTTIME_MINUTE) ?? '00';
    _mondayEndHour =
        await storage.read(key: globals.FSS_MONDAY_ENDTIME_HOUR) ?? '17';
    _mondayEndMinute =
        await storage.read(key: globals.FSS_MONDAY_ENDTIME_MINUTE) ?? '00';
    _tuesdayStartHour =
        await storage.read(key: globals.FSS_TUESDAY_STARTTIME_HOUR) ?? '09';
    _tuesdayStartMinute =
        await storage.read(key: globals.FSS_TUESDAY_STARTTIME_MINUTE) ?? '00';
    _tuesdayEndHour =
        await storage.read(key: globals.FSS_TUESDAY_ENDTIME_HOUR) ?? '17';
    _tuesdayEndMinute =
        await storage.read(key: globals.FSS_TUESDAY_ENDTIME_MINUTE) ?? '00';
    _wednesdayStartHour =
        await storage.read(key: globals.FSS_WEDNESDAY_STARTTIME_HOUR) ?? '09';
    _wednesdayStartMinute =
        await storage.read(key: globals.FSS_WEDNESDAY_STARTTIME_MINUTE) ?? '00';
    _wednesdayEndHour =
        await storage.read(key: globals.FSS_WEDNESDAY_ENDTIME_HOUR) ?? '17';
    _wednesdayEndMinute =
        await storage.read(key: globals.FSS_WEDNESDAY_ENDTIME_MINUTE) ?? '00';
    _thursdayStartHour =
        await storage.read(key: globals.FSS_THURSDAY_STARTTIME_HOUR) ?? '09';
    _thursdayStartMinute =
        await storage.read(key: globals.FSS_THURSDAY_STARTTIME_MINUTE) ?? '00';
    _thursdayEndHour =
        await storage.read(key: globals.FSS_THURSDAY_ENDTIME_HOUR) ?? '17';
    _thursdayEndMinute =
        await storage.read(key: globals.FSS_THURSDAY_ENDTIME_MINUTE) ?? '00';
    _fridayStartHour =
        await storage.read(key: globals.FSS_FRIDAY_STARTTIME_HOUR) ?? '09';
    _fridayStartMinute =
        await storage.read(key: globals.FSS_FRIDAY_STARTTIME_MINUTE) ?? '00';
    _fridayEndHour =
        await storage.read(key: globals.FSS_FRIDAY_ENDTIME_HOUR) ?? '17';
    _fridayEndMinute =
        await storage.read(key: globals.FSS_FRIDAY_ENDTIME_MINUTE) ?? '00';
    _saturdayStartHour =
        await storage.read(key: globals.FSS_SATURDAY_STARTTIME_HOUR) ?? '09';
    _saturdayStartMinute =
        await storage.read(key: globals.FSS_SATURDAY_STARTTIME_MINUTE) ?? '00';
    _saturdayEndHour =
        await storage.read(key: globals.FSS_SATURDAY_ENDTIME_HOUR) ?? '17';
    _saturdayEndMinute =
        await storage.read(key: globals.FSS_SATURDAY_ENDTIME_MINUTE) ?? '00';
    _sundayStartHour =
        await storage.read(key: globals.FSS_SUNDAY_STARTTIME_HOUR) ?? '09';
    _sundayStartMinute =
        await storage.read(key: globals.FSS_SUNDAY_STARTTIME_MINUTE) ?? '00';
    _sundayEndHour =
        await storage.read(key: globals.FSS_SUNDAY_ENDTIME_HOUR) ?? '17';
    _sundayEndMinute =
        await storage.read(key: globals.FSS_SUNDAY_ENDTIME_MINUTE) ?? '00';

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Alert Times'),
      ),
      body: Column(
        children: [
          // Monday section
          ListTile(
            title: _buildTitleRow(
                day: 'monday',
                startHour: _mondayStartHour,
                startMinute: _mondayStartMinute,
                endHour: _mondayEndHour,
                endMinute: _mondayEndMinute),
            subtitle: const Text('Monday'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch(
                  value: _mondaySwitch,
                  onChanged: (value) async {
                    await storage.write(
                        key: globals.FSS_MONDAY_SWITCH,
                        value: value.toString());
                    setState(() {
                      _mondaySwitch = value;
                    });
                  },
                ),
              ],
            ),
          ),
          // Tuesday section
          ListTile(
            title: _buildTitleRow(
                day: 'tuesday',
                startHour: _tuesdayStartHour,
                startMinute: _tuesdayStartMinute,
                endHour: _tuesdayEndHour,
                endMinute: _tuesdayEndMinute),
            subtitle: const Text('Tuesday'),
            trailing: Switch(
              value: _tuesdaySwitch,
              onChanged: (value) async {
                await storage.write(
                    key: globals.FSS_TUESDAY_SWITCH, value: value.toString());
                setState(() {
                  _tuesdaySwitch = value;
                });
              },
            ),
          ),
          // Wednesday section
          ListTile(
            title: _buildTitleRow(
                day: 'wednesday',
                startHour: _wednesdayStartHour,
                startMinute: _wednesdayStartMinute,
                endHour: _wednesdayEndHour,
                endMinute: _wednesdayEndMinute),
            subtitle: const Text('Wednesday'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch(
                  value: _wednesdaySwitch,
                  onChanged: (value) async {
                    await storage.write(
                        key: globals.FSS_WEDNESDAY_SWITCH,
                        value: value.toString());
                    setState(() {
                      _wednesdaySwitch = value;
                    });
                  },
                ),
              ],
            ),
          ),
          // Thursday section
          ListTile(
            title: _buildTitleRow(
                day: 'thursday',
                startHour: _thursdayStartHour,
                startMinute: _thursdayStartMinute,
                endHour: _thursdayEndHour,
                endMinute: _thursdayEndMinute),
            subtitle: const Text('Thursday'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch(
                  value: _thursdaySwitch,
                  onChanged: (value) async {
                    await storage.write(
                        key: globals.FSS_THURSDAY_SWITCH,
                        value: value.toString());
                    setState(() {
                      _thursdaySwitch = value;
                    });
                  },
                ),
              ],
            ),
          ),
          // Friday section
          ListTile(
            title: _buildTitleRow(
                day: 'friday',
                startHour: _fridayStartHour,
                startMinute: _fridayStartMinute,
                endHour: _fridayEndHour,
                endMinute: _fridayEndMinute),
            subtitle: const Text('Friday'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch(
                  value: _fridaySwitch,
                  onChanged: (value) async {
                    await storage.write(
                        key: globals.FSS_FRIDAY_SWITCH,
                        value: value.toString());
                    setState(() {
                      _fridaySwitch = value;
                    });
                  },
                ),
              ],
            ),
          ),
          // Saturday section
          ListTile(
            title: _buildTitleRow(
                day: 'saturday',
                startHour: _saturdayStartHour,
                startMinute: _saturdayStartMinute,
                endHour: _saturdayEndHour,
                endMinute: _saturdayEndMinute),
            subtitle: const Text('Saturday'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch(
                  value: _saturdaySwitch,
                  onChanged: (value) async {
                    await storage.write(
                        key: globals.FSS_SATURDAY_SWITCH,
                        value: value.toString());
                    setState(() {
                      _saturdaySwitch = value;
                    });
                  },
                ),
              ],
            ),
          ),
          // Sunday section
          ListTile(
            title: _buildTitleRow(
                day: 'sunday',
                startHour: _sundayStartHour,
                startMinute: _sundayStartMinute,
                endHour: _sundayEndHour,
                endMinute: _sundayEndMinute),
            subtitle: const Text('Sunday'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch(
                  value: _sundaySwitch,
                  onChanged: (value) async {
                    await storage.write(
                        key: globals.FSS_SUNDAY_SWITCH,
                        value: value.toString());
                    setState(() {
                      _sundaySwitch = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleRow(
      {required String day,
      required String startHour,
      required String startMinute,
      required String endHour,
      required String endMinute}) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => _showTimePicker(
              day: day,
              startOrEnd: 'start',
              hour: startHour,
              minute: startMinute),
          child: Text(
            convertTimeToString(startHour, startMinute),
            style: startEndTimeStyle,
          ),
        ),
        const Text(' - '),
        GestureDetector(
          onTap: () => _showTimePicker(
              day: day, startOrEnd: 'end', hour: endHour, minute: endMinute),
          child: Text(
            convertTimeToString(endHour, endMinute),
            style: startEndTimeStyle,
          ),
        ),
      ],
    );
  }

  _showTimePicker(
      {required day,
      required String startOrEnd,
      required String hour,
      required String minute}) {
    showTimePicker(
      context: context,
      initialTime:
          TimeOfDay.fromDateTime(DateTime.parse("2022-01-01 $hour:$minute:00")),
      helpText: 'Select $startOrEnd time',
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    ).then((selectedTime) async {
      if (selectedTime != null) {
        // Update FlutterSecureStorage and UI
        switch (day) {
          case 'monday':
            late String hour;
            late String minute;

            // Convert to properly save to FlutterSecureStorage
            if (selectedTime.hour < 10) {
              hour = '0${selectedTime.hour}';
            } else {
              hour = selectedTime.hour.toString();
            }

            if (selectedTime.minute < 10) {
              minute = '0${selectedTime.minute}';
            } else {
              minute = selectedTime.minute.toString();
            }

            if (startOrEnd == 'start') {
              await storage.write(
                  key: globals.FSS_MONDAY_STARTTIME_HOUR, value: hour);
              await storage.write(
                  key: globals.FSS_MONDAY_STARTTIME_MINUTE, value: minute);

              // update UI
              _mondayStartHour = hour;
              _mondayStartMinute = minute;
            } else {
              await storage.write(
                  key: globals.FSS_MONDAY_ENDTIME_HOUR, value: hour);
              await storage.write(
                  key: globals.FSS_MONDAY_ENDTIME_MINUTE, value: minute);

              // update UI
              _mondayEndHour = hour;
              _mondayEndMinute = minute;
            }
            break;
          case 'tuesday':
            late String hour;
            late String minute;

            // Convert to properly save to FlutterSecureStorage
            if (selectedTime.hour < 10) {
              hour = '0${selectedTime.hour}';
            } else {
              hour = selectedTime.hour.toString();
            }

            if (selectedTime.minute < 10) {
              minute = '0${selectedTime.minute}';
            } else {
              minute = selectedTime.minute.toString();
            }
            if (startOrEnd == 'start') {
              await storage.write(
                  key: globals.FSS_TUESDAY_STARTTIME_HOUR, value: hour);
              await storage.write(
                  key: globals.FSS_TUESDAY_STARTTIME_MINUTE, value: minute);

              // update UI
              _tuesdayStartHour = hour;
              _tuesdayStartMinute = minute;
            } else {
              await storage.write(
                  key: globals.FSS_TUESDAY_ENDTIME_HOUR, value: hour);
              await storage.write(
                  key: globals.FSS_TUESDAY_ENDTIME_MINUTE, value: minute);

              // update UI
              _tuesdayEndHour = hour;
              _tuesdayEndMinute = minute;
            }
            break;
          case 'wednesday':
            late String hour;
            late String minute;

            // Convert to properly save to FlutterSecureStorage
            if (selectedTime.hour < 10) {
              hour = '0${selectedTime.hour}';
            } else {
              hour = selectedTime.hour.toString();
            }

            if (selectedTime.minute < 10) {
              minute = '0${selectedTime.minute}';
            } else {
              minute = selectedTime.minute.toString();
            }

            if (startOrEnd == 'start') {
              await storage.write(
                  key: globals.FSS_WEDNESDAY_STARTTIME_HOUR, value: hour);
              await storage.write(
                  key: globals.FSS_WEDNESDAY_STARTTIME_MINUTE, value: minute);

              // update UI
              _wednesdayStartHour = hour;
              _wednesdayStartMinute = minute;
            } else {
              await storage.write(
                  key: globals.FSS_WEDNESDAY_ENDTIME_HOUR, value: hour);
              await storage.write(
                  key: globals.FSS_WEDNESDAY_ENDTIME_MINUTE, value: minute);

              // update UI
              _wednesdayEndHour = hour;
              _wednesdayEndMinute = minute;
            }
            break;
          case 'thursday':
            late String hour;
            late String minute;

            // Convert to properly save to FlutterSecureStorage
            if (selectedTime.hour < 10) {
              hour = '0${selectedTime.hour}';
            } else {
              hour = selectedTime.hour.toString();
            }

            if (selectedTime.minute < 10) {
              minute = '0${selectedTime.minute}';
            } else {
              minute = selectedTime.minute.toString();
            }

            if (startOrEnd == 'start') {
              await storage.write(
                  key: globals.FSS_THURSDAY_STARTTIME_HOUR, value: hour);
              await storage.write(
                  key: globals.FSS_THURSDAY_STARTTIME_MINUTE, value: minute);

              // update UI
              _thursdayStartHour = hour;
              _thursdayStartMinute = minute;
            } else {
              await storage.write(
                  key: globals.FSS_THURSDAY_ENDTIME_HOUR, value: hour);
              await storage.write(
                  key: globals.FSS_THURSDAY_ENDTIME_MINUTE, value: minute);

              // update UI
              _thursdayEndHour = hour;
              _thursdayEndMinute = minute;
            }
            break;
          case 'friday':
            late String hour;
            late String minute;

            // Convert to properly save to FlutterSecureStorage
            if (selectedTime.hour < 10) {
              hour = '0${selectedTime.hour}';
            } else {
              hour = selectedTime.hour.toString();
            }

            if (selectedTime.minute < 10) {
              minute = '0${selectedTime.minute}';
            } else {
              minute = selectedTime.minute.toString();
            }

            if (startOrEnd == 'start') {
              await storage.write(
                  key: globals.FSS_FRIDAY_STARTTIME_HOUR, value: hour);
              await storage.write(
                  key: globals.FSS_FRIDAY_STARTTIME_MINUTE, value: minute);

              // update UI
              _fridayStartHour = hour;
              _fridayStartMinute = minute;
            } else {
              await storage.write(
                  key: globals.FSS_FRIDAY_ENDTIME_HOUR, value: hour);
              await storage.write(
                  key: globals.FSS_FRIDAY_ENDTIME_MINUTE, value: minute);

              // update UI
              _fridayEndHour = hour;
              _fridayEndMinute = minute;
            }
            break;
          case 'saturday':
            late String hour;
            late String minute;

            // Convert to properly save to FlutterSecureStorage
            if (selectedTime.hour < 10) {
              hour = '0${selectedTime.hour}';
            } else {
              hour = selectedTime.hour.toString();
            }

            if (selectedTime.minute < 10) {
              minute = '0${selectedTime.minute}';
            } else {
              minute = selectedTime.minute.toString();
            }

            if (startOrEnd == 'start') {
              await storage.write(
                  key: globals.FSS_SATURDAY_STARTTIME_HOUR, value: hour);
              await storage.write(
                  key: globals.FSS_SATURDAY_STARTTIME_MINUTE, value: minute);

              // update UI
              _saturdayStartHour = hour;
              _saturdayStartMinute = minute;
            } else {
              await storage.write(
                  key: globals.FSS_SATURDAY_ENDTIME_HOUR, value: hour);
              await storage.write(
                  key: globals.FSS_SATURDAY_ENDTIME_MINUTE, value: minute);

              // update UI
              _saturdayEndHour = hour;
              _saturdayEndMinute = minute;
            }
            break;
          case 'sunday':
            late String hour;
            late String minute;

            // Convert to properly save to FlutterSecureStorage
            if (selectedTime.hour < 10) {
              hour = '0${selectedTime.hour}';
            } else {
              hour = selectedTime.hour.toString();
            }

            if (selectedTime.minute < 10) {
              minute = '0${selectedTime.minute}';
            } else {
              minute = selectedTime.minute.toString();
            }

            if (startOrEnd == 'start') {
              await storage.write(
                  key: globals.FSS_SUNDAY_STARTTIME_HOUR, value: hour);
              await storage.write(
                  key: globals.FSS_SUNDAY_STARTTIME_MINUTE, value: minute);

              // update UI
              _sundayStartHour = hour;
              _sundayStartMinute = minute;
            } else {
              await storage.write(
                  key: globals.FSS_SUNDAY_ENDTIME_HOUR, value: hour);
              await storage.write(
                  key: globals.FSS_SUNDAY_ENDTIME_MINUTE, value: minute);

              // update UI
              _sundayEndHour = hour;
              _sundayEndMinute = minute;
            }
            break;
        }

        if (context.mounted) {
          setState(() {});
        }
      }
    });
  }

  String convertTimeToString(String hour, String minute) {
    late String amPM;
    if (hour == '00') {
      hour = '12';
      amPM = 'AM';
      return '$hour:$minute$amPM';
    } else if (hour[0] == '0' && hour[1] != '0') {
      hour = hour[1];
      amPM = 'AM';
    } else {
      late int pmTime;
      if (int.parse(hour) > 12) {
        pmTime = int.parse(hour) - 12;
        amPM = 'PM';
      } else {
        pmTime = int.parse(hour);
        amPM = 'AM';
      }

      if (pmTime == 0) {
        pmTime = 12;
      }
      hour = pmTime.toString();
    }
    return '$hour:$minute$amPM';
  }
}
