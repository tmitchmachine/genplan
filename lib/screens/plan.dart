import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart'; // Import MDI icons
import 'package:share_plus/share_plus.dart';

class PlanPage extends StatelessWidget {
  final String planDetails;

  PlanPage({required this.planDetails});

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
        actions: [
          Padding(
            padding: const EdgeInsets.only(
                right: 16.0), // Adjust padding to move the icon left
            child: IconButton(
              icon: Icon(MdiIcons.calendar), // Use sleek MDI calendar icon
              onPressed: () {
                // Handle calendar icon press
                print('Calendar icon pressed');
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Center(
                  child: Text(
                    planDetails, // Display the plan details as a single string
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      height: 1.5, // Line height for readability
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                  // Share the plan details
                  shareText(planDetails);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.transparent, // Set background to transparent
                  foregroundColor: Colors.white, // Text color
                  elevation: 0, // Remove shadow
                  minimumSize: Size(200, 50), // Button size like in home.dart
                  padding: EdgeInsets.symmetric(
                      vertical: 16, horizontal: 32), // Button padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8.0), // Match the container's border radius
                  ),
                ),
                child: const Text('Share'),
              ),
            ),
            SizedBox(height: 16), // Space between Share and Close buttons
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.transparent, // Set background to transparent
                foregroundColor: Colors.grey, // Grey text color for "Close"
                elevation: 0, // No shadow
                minimumSize: Size(200, 50), // Matching size with Share button
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
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
    );
  }

  void shareText(String text) {
    Share.share(text, subject: 'Sharing a Plan'); // Add subject if needed
  }
}
