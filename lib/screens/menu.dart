import 'package:flutter/material.dart';
import 'package:genplan/screens/sign_in_options.dart';
import 'package:genplan/screens/interests.dart'; // Use OnboardingOne if Interests doesn't exist
import 'package:genplan/screens/location.dart';
import 'package:genplan/screens/notification.dart'
    as custom_notification; // Aliased import
import 'package:genplan/screens/personalize_experience.dart'; // Import PersonalizeExperience screen
import 'package:genplan/screens/home.dart'; // Import HomePage screen
import 'package:genplan/screens/liked_ideas.dart'; // New screen for liked ideas
import 'package:genplan/screens/disliked_ideas.dart'; // Import DislikedIdeas screen

class MenuPage extends StatelessWidget {
  final dynamic auth; // Replace 'dynamic' with the actual type of 'auth'

  MenuPage({required this.auth});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomePage(), // Navigate to HomePage
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
                    builder: (context) =>
                        Interests(), // Corrected to OnboardingOne if needed
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

            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => custom_notification
                        .Notification(), // Use aliased import
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
                    builder: (context) =>
                        PersonalizeExperience(), // Navigate to PersonalizeExperience screen
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

            // New Liked Ideas menu item
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        LikedIdeasPage(), // Navigate to Liked Ideas screen
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

            // New Disliked Ideas menu item
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        DislikedIdeasPage(), // Navigate to Disliked Ideas screen
                  ),
                );
              },
              child: Text(
                'Disliked Ideas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
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
