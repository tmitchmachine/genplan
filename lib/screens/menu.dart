import 'package:flutter/material.dart';
import 'package:genplan/screens/sign_in_options.dart';
import 'package:genplan/screens/interests.dart';
import 'package:genplan/screens/location.dart';
import 'package:genplan/screens/notification.dart' as custom_notification;
import 'package:genplan/screens/personalize_experience.dart';
import 'package:genplan/screens/home.dart';
import 'package:genplan/screens/liked_ideas.dart';
import 'package:genplan/screens/disliked_ideas.dart';
import 'package:genplan/screens/mode.dart'; // Import the ModePage
import 'package:day_night_switcher/day_night_switcher.dart'; // Import for day/night mode switcher

class MenuPage extends StatefulWidget {
  final dynamic auth;

  MenuPage({required this.auth});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  bool isDarkModeEnabled = false; // To track mode state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          },
        ),
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
                    builder: (context) => Interests(),
                  ),
                );
              },
              child: Text(
                'Update Interests',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(color: Colors.grey),
            SizedBox(height: 16),

            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Location(),
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

            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => custom_notification.Notification(),
                  ),
                );
              },
              child: Text(
                'Update Notification',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(color: Colors.grey),
            SizedBox(height: 16),

            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PersonalizeExperience(),
                  ),
                );
              },
              child: Text(
                'Personalize Experience',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(color: Colors.grey),
            SizedBox(height: 16),

            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LikedIdeasPage(),
                  ),
                );
              },
              child: Text(
                'Liked Ideas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(color: Colors.grey),
            SizedBox(height: 16),

            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DislikedIdeasPage(),
                  ),
                );
              },
              child: Text(
                'Disliked Ideas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(color: Colors.grey),
            SizedBox(height: 16),

            // New "Mode" item to link to ModePage
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ModePage(), // Navigate to ModePage
                  ),
                );
              },
              child: Text(
                'Mode',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(color: Colors.grey),
            SizedBox(height: 32),

            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await widget.auth.signOut();
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
