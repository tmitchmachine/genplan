import 'package:flutter/material.dart';
import 'package:genplan/screens/sign_in_options.dart';
import 'package:genplan/screens/interests.dart'; // Use OnboardingOne if Interests doesn't exist
import 'package:genplan/screens/location.dart';

class MenuPage extends StatelessWidget {
  final dynamic auth; // Replace 'dynamic' with the actual type of 'auth'

  MenuPage({required this.auth});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        Interests(), // Corrected to OnboardingOne
                  ),
                );
              },
              child: Text(
                'Update Interests',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(color: Colors.grey),
            SizedBox(height: 16), // Space between items

            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        Location(), // Correct screen for Location
                  ),
                );
              },
              child: Text(
                'Update Location',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(color: Colors.grey),
            SizedBox(height: 16),

            Text(
              'Update Notification',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(color: Colors.grey),
            SizedBox(height: 16),

            Text(
              'Personalize Experience',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(color: Colors.grey),
            SizedBox(height: 32),

            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await auth.signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => SignInOptionsPage(),
                    ),
                  );
                },
                child: const Text('Log Out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
