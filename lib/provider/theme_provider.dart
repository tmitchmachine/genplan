import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadThemePreference();
  }

  Future<void> toggleMode() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners(); // Notify listeners to rebuild UI
    await _saveThemePreference(); // Save preference to Firestore
  }

  ThemeData get themeData {
    return _isDarkMode ? ThemeData.dark() : ThemeData.light();
  }

  Future<void> _loadThemePreference() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          String mode = doc.get('themeMode') ?? 'modeLight';
          _isDarkMode = mode == 'modeDark';
        }
      }
    } catch (e) {
      print('Error loading theme preference: $e');
    }
    notifyListeners(); // Ensure UI updates when loading
  }

  Future<void> _saveThemePreference() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'themeMode': _isDarkMode ? 'modeDark' : 'modeLight',
        }, SetOptions(merge: true));
      }
    } catch (e) {
      print('Error saving theme preference: $e');
    }
  }
}
