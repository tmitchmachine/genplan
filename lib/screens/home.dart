import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math'; // For generating random ideas
import 'package:genplan/screens/plan.dart'; // Ensure this is correct
import 'package:genplan/screens/menu.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'dart:convert'; // For JSON encoding/decoding
import 'dart:async';

class HomePage extends StatefulWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isThumbsUpSelected = false;
  bool _isThumbsDownSelected = false;

  List<String> _planIdeas = [];
  String _generatedIdea = '';
  String _fullPlan = '';

  @override
  void initState() {
    super.initState();
    _fetchIdeasFromFirestore(); // Fetch ideas when the page loads
  }

  Future<void> _fetchIdeasFromFirestore() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('ideas').get();
      final ideas = snapshot.docs.map((doc) => doc['idea'] as String).toList();

      if (ideas.isNotEmpty) {
        setState(() {
          _planIdeas = ideas;
          _generateIdea(); // Generate an idea after fetching
        });
      } else {
        print('No ideas found in Firestore.');
      }
    } catch (e) {
      print('Error fetching ideas from Firestore: $e');
    }
  }

  void _generateIdea() {
    if (_planIdeas.isNotEmpty) {
      final random = Random();
      setState(() {
        _generatedIdea = _planIdeas[random.nextInt(_planIdeas.length)];
      });
    }
  }

  Future<void> _saveFeedbackToFirestore(String feedbackType) async {
    final user = widget.auth.currentUser;

    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection(feedbackType) // Use the feedbackType directly
            .add({
          'idea': _generatedIdea,
          'timestamp': Timestamp.now(),
        });
        print('Feedback saved to Firestore: $feedbackType');
      } catch (e) {
        print('Error saving feedback to Firestore: $e');
      }
    } else {
      print('No user signed in.');
    }
  }

  Future<void> _savePlanToFirestore(String idea, String plan) async {
    final user = widget.auth.currentUser;

    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('generated_plans') // Use the specific sub-collection
            .add({
          'idea': idea,
          'plan': plan,
          'createdAt': Timestamp.now(),
        });
        print('Plan saved to Firestore: $plan');
      } catch (e) {
        print('Error saving plan to Firestore: $e');
      }
    } else {
      print('No user signed in.');
    }
  }

  void _handleThumbsUp() {
    setState(() {
      _isThumbsUpSelected = true;
      _isThumbsDownSelected = false;
    });

    Future.delayed(Duration(milliseconds: 300), () {
      _saveFeedbackToFirestore('liked_ideas'); // Save feedback to Firestore
      _generateIdea(); // Generate a new idea after the transition
      setState(() {
        _isThumbsUpSelected = false;
      });
    });
  }

  void _handleThumbsDown() {
    setState(() {
      _isThumbsDownSelected = true;
      _isThumbsUpSelected = false;
    });

    Future.delayed(Duration(milliseconds: 300), () {
      _saveFeedbackToFirestore('disliked_ideas'); // Save feedback to Firestore
      _generateIdea(); // Generate a new idea after the transition
      setState(() {
        _isThumbsDownSelected = false;
      });
    });
  }

  Future<void> _handleGeneratePlan() async {
    final url = Uri.parse(
        'https://api.replicate.com/v1/models/meta/meta-llama-3-70b-instruct/predictions');

    final headers = {
      'Authorization': 'Bearer r8_SnnoM8rom6gUHZpb1sxPg74yJeOZ3Bl15Rw9g',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "input": {
        "top_k": 0,
        "top_p": 0.9,
        "prompt": _generatedIdea,
        "max_tokens": 512,
        "min_tokens": 0,
        "temperature": 0.6,
        "system_prompt": "You are a helpful assistant",
        "length_penalty": 1,
        "stop_sequences": "<|end_of_text|>,<|eot_id|>",
        "prompt_template":
            "<|begin_of_text|><|start_header_id|>system<|end_header_id|>\n\nYou are a helpful assistant<|eot_id|><|start_header_id|>user<|end_header_id|>\n\n{prompt}<|eot_id|><|start_header_id|>assistant<|end_header_id|>\n\n",
        "presence_penalty": 1.15,
        "log_performance_metrics": false
      }
    });

    try {
      // Step 1: Make the initial POST request
      final postResponse = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (postResponse.statusCode == 201) {
        final responseData = jsonDecode(postResponse.body);
        final predictionId = responseData['id'];

        if (predictionId != null) {
          print('Prediction ID: $predictionId');

          // Step 2: Polling the result every 2 seconds until output is available
          Timer.periodic(Duration(seconds: 2), (timer) async {
            final resultUrl = Uri.parse(
                'https://api.replicate.com/v1/predictions/$predictionId');

            final resultResponse = await http.get(resultUrl, headers: headers);

            if (resultResponse.statusCode == 200) {
              final resultData = jsonDecode(resultResponse.body);
              final output = resultData['output'];

              if (output != null) {
                final outputString = output.join();
                print('Prediction Output: $outputString');

                timer.cancel(); // Stop polling once we get the result

                // Save the plan to Firestore
                await _savePlanToFirestore(_generatedIdea, outputString);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlanPage(planDetails: outputString),
                  ),
                );
              } else {
                print('Prediction still in progress...');
              }
            } else {
              print(
                  'Failed to fetch result with status code: ${resultResponse.statusCode}');
              timer.cancel(); // Stop polling if there is an error
            }
          });
        } else {
          print('No prediction ID found in response.');
        }
      } else {
        print('Failed with status code: ${postResponse.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.network(
            'https://firebasestorage.googleapis.com/v0/b/genplan-007.appspot.com/o/menu.png?alt=media&token=1dfccf5d-78da-42d4-a0a9-5a4ecda61ebd',
            width: 24,
            height: 24,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MenuPage(auth: widget.auth),
              ),
            );
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
            top: MediaQuery.of(context).size.height * 0.5 - 20 - 160,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 300), // Faster transition
                transitionBuilder: (widget, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: widget,
                  );
                },
                child: Text(
                  _generatedIdea, // Display the generated idea
                  key: ValueKey<String>(_generatedIdea),
                  style: TextStyle(fontSize: 22),
                  textAlign: TextAlign.center, // Center align the text
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Thumbs up icon with a nice UI
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: GestureDetector(
                    onTap: _handleThumbsUp,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: _isThumbsUpSelected ? 48 : 40,
                      height: _isThumbsUpSelected ? 48 : 40,
                      decoration: BoxDecoration(
                        color: _isThumbsUpSelected
                            ? Colors.black
                            : Colors.transparent, // Transparent when unselected
                        shape: BoxShape.circle,
                        boxShadow: [
                          if (_isThumbsUpSelected)
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.3), // Lighter shadow
                              spreadRadius: 3,
                              blurRadius: 8,
                            ),
                        ],
                      ),
                      child: Icon(
                        Icons.thumb_up_alt_rounded,
                        color: _isThumbsUpSelected
                            ? Colors.white
                            : Colors
                                .grey.shade400, // Lighter gray when unselected
                        size: _isThumbsUpSelected ? 28 : 24,
                      ),
                    ),
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
                    onPressed: _handleGeneratePlan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, // Background color
                      foregroundColor: Colors.white, // Text color
                      elevation: 0,
                      minimumSize: Size(200, 50),
                      padding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 32,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      side: BorderSide(
                        color: Colors.transparent, // Border color
                      ),
                    ),
                    child: const Text('Generate Plan'),
                  ),
                ),
                // Thumbs down icon with a nice UI
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: GestureDetector(
                    onTap: _handleThumbsDown,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: _isThumbsDownSelected ? 48 : 40,
                      height: _isThumbsDownSelected ? 48 : 40,
                      decoration: BoxDecoration(
                        color: _isThumbsDownSelected
                            ? Colors.black
                            : Colors.transparent, // Transparent when unselected
                        shape: BoxShape.circle,
                        boxShadow: [
                          if (_isThumbsDownSelected)
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.3), // Lighter shadow
                              spreadRadius: 3,
                              blurRadius: 8,
                            ),
                        ],
                      ),
                      child: Icon(
                        Icons.thumb_down_alt_rounded,
                        color: _isThumbsDownSelected
                            ? Colors.white
                            : Colors
                                .grey.shade400, // Lighter gray when unselected
                        size: _isThumbsDownSelected ? 28 : 24,
                      ),
                    ),
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
