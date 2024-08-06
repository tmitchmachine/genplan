import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to My App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('This is a basic home screen example.'),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Button press logic here
                print('Button pressed!');
              },
              child: Text('Click Me'),
            ),
          ],
        ),
      ),
    );
  }
}
