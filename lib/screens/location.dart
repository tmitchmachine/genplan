import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Location extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  bool _locationSharingEnabled = false;
  bool _usePreciseLocation = true;
  String _selectedLocation = 'No location selected';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _locationSharingEnabled =
          prefs.getBool('locationSharingEnabled') ?? false;
      _usePreciseLocation = prefs.getBool('usePreciseLocation') ?? true;
      _selectedLocation =
          prefs.getString('selectedLocation') ?? 'No location selected';
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('locationSharingEnabled', _locationSharingEnabled);
    await prefs.setBool('usePreciseLocation', _usePreciseLocation);
    await prefs.setString('selectedLocation', _selectedLocation);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Preferences saved successfully')),
    );
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
                    // Reset location preference when location sharing is disabled
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
                    if (!value!) {
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
