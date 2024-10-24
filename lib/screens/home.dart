import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:genplan/screens/plan.dart';
import 'package:genplan/screens/menu.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:genplan/data/ideas.dart';
import 'package:provider/provider.dart';
import 'package:genplan/provider/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isThumbsUpSelected = false;
  bool _isThumbsDownSelected = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _userLocation;
  bool _locationSharingEnabled = false;
  bool _usePreciseLocation = true;

  Future<void> _loadLocationPreferences() async {
    final user = widget.auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _locationSharingEnabled = data['locationSharingEnabled'] ?? false;
          _usePreciseLocation = data['usePreciseLocation'] ?? true;
          _userLocation = data['selectedLocation'];
        });
      }
    }
  }

  List<String> _planIdeas = [];
  String _generatedIdea = '';
  String _fullPlan = '';

  @override
  void initState() {
    super.initState();
    _fetchIdeasFromLocal();
    _loadLocationPreferences();
  }

  void _fetchIdeasFromLocal() {
    setState(() {
      _planIdeas = ideasList;
      _generateIdea();
    });
  }

  void _generateIdea() {
    if (_planIdeas.isNotEmpty) {
      final random = Random();
      setState(() {
        _generatedIdea = _planIdeas[random.nextInt(_planIdeas.length)];
      });
    }
  }

  Future<void> _saveLikedIdea(String idea) async {
    final user = widget.auth.currentUser;
    if (user != null) {
      try {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('liked_ideas')
            .add({
          'idea': idea,
          'timestamp': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        print('Error saving liked idea: $e');
      }
    }
  }

  Future<void> _saveDislikedIdea(String idea) async {
    final user = widget.auth.currentUser;
    if (user != null) {
      try {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('disliked_ideas')
            .add({
          'idea': idea,
          'timestamp': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        print('Error saving disliked idea: $e');
      }
    }
  }

  void _handleThumbsUp() async {
    setState(() {
      _isThumbsUpSelected = true;
      _isThumbsDownSelected = false;
    });

    await _saveLikedIdea(_generatedIdea);

    Future.delayed(Duration(milliseconds: 300), () {
      _generateIdea();
      setState(() {
        _isThumbsUpSelected = false;
      });
    });
  }

  void _handleThumbsDown() async {
    setState(() {
      _isThumbsDownSelected = true;
      _isThumbsUpSelected = false;
    });

    await _saveDislikedIdea(_generatedIdea);

    Future.delayed(Duration(milliseconds: 300), () {
      _generateIdea();
      setState(() {
        _isThumbsDownSelected = false;
      });
    });
  }

  Future<void> _handleGeneratePlan() async {
    final url = Uri.parse(
        'https://api.replicate.com/v1/models/meta/meta-llama-3-70b-instruct/predictions');

    String locationContext = '';
    if (_locationSharingEnabled) {
      if (_usePreciseLocation) {
        locationContext = 'The user is located at: $_userLocation. ';
        print(locationContext);
      } else {
        locationContext =
            'The user is in the general area of: $_userLocation. ';
        print(locationContext);
      }
    }

    final headers = {
      'Authorization': 'Bearer r8_9y3jCEB74fd4GZPZILUVUcIF7mPb3pJ1cadkP',
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
        "system_prompt":
            """You are a helpful assistant that outputs a JSON object so that I can add a event to a calendar. I would like it to be formatted like this:
        {
          title: 'Event title',
          description: 'Event description',
          location: 'Event location',
          startDate: DateTime(/* Some date here */),
          endDate: DateTime(/* Some date here */),
        }
        ONLY output the JSON with nothing else
        """,
        "length_penalty": 1,
        "stop_sequences": "<|end_of_text|>,<|eot_id|>",
        "prompt_template":
            '<|begin_of_text|><|start_header_id|>system<|end_header_id|>\n\n"You are a helpful assistant that outputs a JSON object so that I can add a event to a calendar the JSON object will contain ONLY the title, description, location ONLY output the JSON with nothing else the activities should be around the $locationContext area<|eot_id|><|start_header_id|>user<|end_header_id|>\n\n{prompt}<|eot_id|><|start_header_id|>assistant<|end_header_id|>\n\n',
        "presence_penalty": 1.15,
        "log_performance_metrics": false
      }
    });

    try {
      final postResponse = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (postResponse.statusCode == 201) {
        final responseData = jsonDecode(postResponse.body);
        final predictionId = responseData['id'];

        if (predictionId != null) {
          print('Prediction ID: $predictionId $locationContext');

          Timer.periodic(Duration(seconds: 2), (timer) async {
            final resultUrl = Uri.parse(
                'https://api.replicate.com/v1/predictions/$predictionId');

            final resultResponse = await http.get(resultUrl, headers: headers);

            if (resultResponse.statusCode == 200) {
              final resultData = jsonDecode(resultResponse.body);
              final output = resultData['output'];

              if (output != null) {
                final outputString = output.join();
                print('Prediction Output: $outputString $locationContext');

                timer.cancel();

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
              timer.cancel();
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.network(
            'https://firebasestorage.googleapis.com/v0/b/genplan-007.appspot.com/o/menu.png?alt=media&token=1dfccf5d-78da-42d4-a0a9-5a4ecda61ebd',
            width: 24,
            height: 24,
            color: isDarkMode ? Colors.white : Colors.black,
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
                duration: Duration(milliseconds: 300),
                transitionBuilder: (widget, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: widget,
                  );
                },
                child: Text(
                  _generatedIdea,
                  key: ValueKey<String>(_generatedIdea),
                  style: TextStyle(fontSize: 22),
                  textAlign: TextAlign.center,
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
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: GestureDetector(
                    onTap: _handleThumbsUp,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: _isThumbsUpSelected ? 48 : 40,
                      height: _isThumbsUpSelected ? 48 : 40,
                      decoration: BoxDecoration(
                        gradient: _isThumbsUpSelected
                            ? LinearGradient(
                                colors: [Color(0xFF8EA7FA), Color(0xFF0969D4)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        shape: BoxShape.circle,
                        boxShadow: _isThumbsUpSelected
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  spreadRadius: 3,
                                  blurRadius: 8,
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(
                        Icons.thumb_up_alt_rounded,
                        color: _isThumbsUpSelected
                            ? Colors.white
                            : Colors.grey.shade400,
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
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: Size(200, 50),
                      padding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 32,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      side: BorderSide.none,
                    ),
                    child: const Text(
                      'Generate Plan',
                      style: TextStyle(
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: GestureDetector(
                    onTap: _handleThumbsDown,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: _isThumbsDownSelected ? 48 : 40,
                      height: _isThumbsDownSelected ? 48 : 40,
                      decoration: BoxDecoration(
                        gradient: _isThumbsDownSelected
                            ? LinearGradient(
                                colors: [Color(0xFF8EA7FA), Color(0xFF0969D4)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        shape: BoxShape.circle,
                        boxShadow: _isThumbsDownSelected
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  spreadRadius: 3,
                                  blurRadius: 8,
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(
                        Icons.thumb_down_alt_rounded,
                        color: _isThumbsDownSelected
                            ? Colors.white
                            : Colors.grey.shade400,
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
