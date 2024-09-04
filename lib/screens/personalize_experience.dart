import 'package:flutter/material.dart';

class PersonalizeExperience extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personalize Experience'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sync Your Calendar',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Handle Apple Calendar sync
                _syncWithAppleCalendar(context);
              },
              child: Text('Sync Apple Calendar'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // Full-width button
                backgroundColor: Colors.black, // Apple-like color
                foregroundColor: Colors.white, // Text color
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle Google Calendar sync
                _syncWithGoogleCalendar(context);
              },
              child: Text('Sync Google Calendar'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // Full-width button
                backgroundColor: Colors.red, // Google-like color
                foregroundColor: Colors.white, // Text color
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _syncWithAppleCalendar(BuildContext context) {
    // Implement Apple Calendar sync functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Syncing Apple Calendar...')),
    );
  }

  void _syncWithGoogleCalendar(BuildContext context) {
    // Implement Google Calendar sync functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Syncing Google Calendar...')),
    );
  }
}
