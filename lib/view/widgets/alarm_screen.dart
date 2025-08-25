import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class AlarmScreen extends StatefulWidget {
  final String title;
  final String body;
  final int notificationId;

  const AlarmScreen({
    Key? key,
    required this.title,
    required this.body,
    required this.notificationId,
  }) : super(key: key);

  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    // Optionally, play a looping alarm sound here
  }

  void _snoozeAlarm() {
    // Reschedule notification for 5 minutes later
    _notificationsPlugin.zonedSchedule(
      widget.notificationId + 1000,
      widget.title,
      widget.body,
      tz.TZDateTime.now(tz.local).add(Duration(minutes: 5)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id',
          'your_channel_name',
          channelDescription: 'your channel description',
          sound: RawResourceAndroidNotificationSound("alarmsound"),
          autoCancel: false,
          playSound: true,
          priority: Priority.max,
          importance: Importance.max,
          enableVibration: true,
          fullScreenIntent: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: jsonEncode({
        'title': widget.title,
        'body': widget.body,
        'taskId': widget.notificationId + 1000,
        'type': widget.body.contains('Task') ? 'task' : 'event',
      }),
    );
    // Close the screen
    Navigator.of(context).pop();
  }

  void _stopAlarm() {
    // Cancel the notification
    _notificationsPlugin.cancel(widget.notificationId);
    // Close the screen
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              widget.body,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _snoozeAlarm,
                  child: Text('Snooze (5 min)'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _stopAlarm,
                  child: Text('Stop'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
