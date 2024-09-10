import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class PlanPage extends StatelessWidget {
  final String placeholderText = 'Plan Placeholder'; // Fixed the typo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Plan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false, // Removes the menu in the upper left
      ),
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height * 0.5 -
                160, // Aligning with home.dart text
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                placeholderText,
                style: TextStyle(fontSize: 22),
              ),
            ),
          ),
          Positioned(
            bottom: 80, // Move button up by 0.5 inches like in home.dart
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF8EA7FA),
                        Color(0xFF0969D4), // Same gradient as in home.dart
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Share the placeholder text
                      shareText(placeholderText);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.transparent, // Set background to transparent
                      foregroundColor: Colors.white, // Text color
                      elevation: 0, // Remove shadow
                      minimumSize:
                          Size(200, 50), // Button size like in home.dart
                      padding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 32,
                      ), // Button padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8.0), // Match the container's border radius
                      ),
                    ),
                    child: const Text('Share'),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.transparent, // Set background to transparent
                    foregroundColor: Colors.grey, // Grey text color for "Close"
                    elevation: 0, // No shadow
                    minimumSize:
                        Size(200, 50), // Matching size with Share button
                    padding: EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 32,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8.0), // Match border radius
                    ),
                  ),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void shareText(String text) {
    Share.share(text, subject: 'Sharing a Plan'); // Add subject if needed
  }
}
