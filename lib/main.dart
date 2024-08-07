import 'package:flutter/material.dart';
import 'screens/login_page.dart'; // Ensure this path matches your file structure

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GenPlan', // Replace with your app's actual title
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home:
          LoginPage(), // Ensure LoginPage is correctly defined in 'screens/login_page.dart'
    );
  }
}
