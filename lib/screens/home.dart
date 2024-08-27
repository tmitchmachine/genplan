import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:genplan/screens/sign_in_options.dart';

class HomePage extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.network(
            'https://firebasestorage.googleapis.com/v0/b/genplan-007.appspot.com/o/menu.png?alt=media&token=2e8e4ecd-26f7-48f1-80a1-d48de00f9981',
            width: 24,
            height: 24,
          ),
          onPressed: () {
            // Menu button action here
          },
        ),
        title: const Text(
          'Personalized Idea',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height * 0.5 -
                20 -
                160, // Move text 2 inches higher
            left: 0,
            right: 0,
            child: Center(
              child: const Text(
                'Idea Placeholder',
                style: TextStyle(fontSize: 22),
              ),
            ),
          ),
          Positioned(
            bottom: 80, // Move button up by 0.5 inches
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // Space between thumbs up and thumbs down
              children: [
                // Thumbs up icon
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Image.network(
                    'https://firebasestorage.googleapis.com/v0/b/genplan-007.appspot.com/o/thumb_up.png?alt=media&token=46385d68-85ee-4d87-87f5-27ac207efa7d',
                    width: 24,
                    height: 24,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF8EA7FA), Color(0xFF0969D4)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      // Button press logic here
                      await auth.signOut();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => SignInOptionsPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.transparent, // Set background to transparent
                      foregroundColor: Colors.white, // Text color
                      elevation: 0, // Remove shadow
                      minimumSize: Size(200, 50), // Button size
                      padding: EdgeInsets.symmetric(
                          vertical: 16, horizontal: 32), // Button padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8.0), // Match the container's border radius
                      ),
                    ),
                    child: const Text('Generate Plan'),
                  ),
                ),
                // Thumbs down icon
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Image.network(
                    'https://firebasestorage.googleapis.com/v0/b/genplan-007.appspot.com/o/thumb_down.png?alt=media&token=1439cad8-0f8b-48c9-8275-f6b799196cec',
                    width: 24,
                    height: 24,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
