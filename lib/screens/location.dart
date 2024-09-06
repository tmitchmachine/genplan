import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Location extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  bool _locationSharingEnabled = false;
  bool _usePreciseLocation = true;
  String _selectedLocation = 'No location selected';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        setState(() {
          var data = userDoc.data() as Map<String, dynamic>;
          _locationSharingEnabled = data['locationSharingEnabled'] ?? false;
          _usePreciseLocation = data['usePreciseLocation'] ?? true;
          _selectedLocation =
              data['selectedLocation'] ?? 'No location selected';
        });
      }
    }
  }

  Future<void> _savePreferences() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'locationSharingEnabled': _locationSharingEnabled,
        'usePreciseLocation': _usePreciseLocation,
        'selectedLocation': _selectedLocation,
      }, SetOptions(merge: true));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preferences saved successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Preferences'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enable Location Sharing',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: Text('Share my location'),
              value: _locationSharingEnabled,
              onChanged: (bool value) {
                setState(() {
                  _locationSharingEnabled = value;
                  if (!value) {
                    _usePreciseLocation = true;
                    _selectedLocation = 'No location selected';
                  }
                });
              },
            ),
            if (_locationSharingEnabled) ...[
              SizedBox(height: 20),
              Text(
                'Location Mode',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              RadioListTile(
                title: Text('Use Precise Location'),
                value: true,
                groupValue: _usePreciseLocation,
                onChanged: (bool? value) {
                  setState(() {
                    _usePreciseLocation = value!;
                    if (value) {
                      _selectedLocation = 'No location selected';
                    }
                  });
                },
              ),
              RadioListTile(
                title: Text('Share Nearby Location'),
                value: false,
                groupValue: _usePreciseLocation,
                onChanged: (bool? value) {
                  setState(() {
                    _usePreciseLocation = value!;
                    if (!value) {
                      _selectedLocation =
                          'Nearby Location: San Francisco Area'; // Automatically set nearby location
                    }
                  });
                },
              ),
              if (!_usePreciseLocation)
                ListTile(
                  title: Text(_selectedLocation),
                  trailing: Icon(Icons.location_on),
                ),
            ],
            Spacer(),
            ElevatedButton(
              onPressed: _savePreferences,
              child: Text('Save Preferences'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // Full-width button
              ),
            ),
          ],
        ),
      ),
    );
  }
}
