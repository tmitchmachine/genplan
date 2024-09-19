import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider package
import 'package:day_night_switcher/day_night_switcher.dart'; // Import DayNightSwitcher
import 'package:genplan/provider/theme_provider.dart'; // Import ThemeProvider

class ModePage extends StatelessWidget {
  const ModePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Toggle Mode'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Switch between Day and Night Mode',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            DayNightSwitcher(
              isDarkModeEnabled: themeProvider.isDarkMode,
              onStateChanged: (isDarkMode) {
                themeProvider.toggleMode(); // Toggle the global theme
              },
            ),
            const SizedBox(height: 20),
            Text(
              themeProvider.isDarkMode ? 'Night Mode' : 'Day Mode',
              style: TextStyle(
                fontSize: 16,
                color: themeProvider.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
    );
  }
}
