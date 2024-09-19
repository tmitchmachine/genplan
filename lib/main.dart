import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:genplan/firebase_options.dart';
import 'package:genplan/screens/sign_in_options.dart'; // Ensure this path matches your file structure
import 'package:provider/provider.dart'; // Correct import for provider package
import 'package:genplan/provider/theme_provider.dart'; // Correct import for ThemeProvider

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(), // Initialize ThemeProvider
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'GenPlan', // Replace with your app's actual title
            theme: themeProvider.themeData, // Apply theme dynamically
            home:
                SignInOptionsPage(), // Replace with your actual initial screen
          );
        },
      ),
    );
  }
}
