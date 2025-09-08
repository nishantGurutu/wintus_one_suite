import 'package:flutter/material.dart';

class AlarmScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6A1B9A), Color(0xFFAB47BC)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '1:54',
              style: TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Sun, Sep 18',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Alarm',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 50),
            IconButton(
              icon: Icon(Icons.close, size: 40, color: Colors.white),
              onPressed: () {
                // Handle dismiss action
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle snooze action (5 mins)
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      'Snooze 5 mins',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    // Handle reschedule action
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
