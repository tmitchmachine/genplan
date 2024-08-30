import 'package:flutter/material.dart';

class OnboardingOne extends StatefulWidget {
  @override
  _OnboardingOneState createState() => _OnboardingOneState();
}

class _OnboardingOneState extends State<OnboardingOne> {
  final TextEditingController _interestController = TextEditingController();
  final List<String> _interests = [];

  void _addInterest() {
    final interest = _interestController.text.trim();
    if (interest.isNotEmpty && !_interests.contains(interest)) {
      setState(() {
        _interests.add(interest);
      });
      _interestController.clear();
    }
  }

  void _removeInterest(String interest) {
    setState(() {
      _interests.remove(interest);
    });
  }

  @override
  void dispose() {
    _interestController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Your Interests'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter your interests:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _interestController,
                    decoration: InputDecoration(
                      hintText: 'Type an interest...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addInterest,
                  child: Text('Add'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _interests.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_interests[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _removeInterest(_interests[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the next screen or process the selected interests
            // For example:
            // Navigator.push(context, MaterialPageRoute(builder: (context) => NextScreen()));
          },
          child: Text('Continue'),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
          ),
        ),
      ),
    );
  }
}
