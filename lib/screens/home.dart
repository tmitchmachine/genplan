import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math'; // For generating random ideas
import 'package:genplan/screens/plan.dart'; // Ensure this is correct
import 'package:genplan/screens/menu.dart';

class HomePage extends StatefulWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isThumbsUpSelected = false;
  bool _isThumbsDownSelected = false;

  // Predefined list of AI-generated plan ideas
  final List<String> _planIdeas = [
    "Start a morning meditation routine",
    "Plan a weekend getaway to the mountains",
    "Create a weekly meal plan for healthy eating",
    "Begin a new book you've always wanted to read",
    "Explore a new hobby like painting or photography",
    "Organize a family game night",
    "Plan a digital detox day",
    "Set up a home workout schedule",
    "Cook a new recipe from a different culture",
    "Take an online course to learn a new skill",
  ];

  String _generatedIdea = '';

  @override
  void initState() {
    super.initState();
    _generateIdea(); // Generate an idea when the page loads
  }

  void _generateIdea() {
    final random = Random();
    setState(() {
      _generatedIdea = _planIdeas[random.nextInt(_planIdeas.length)];
    });
  }

  void _handleThumbsUp() {
    setState(() {
      _isThumbsUpSelected = true;
      _isThumbsDownSelected = false;
    });

    Future.delayed(Duration(milliseconds: 300), () {
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
      _generateIdea(); // Generate a new idea after the transition
      setState(() {
        _isThumbsDownSelected = false;
      });
    });
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PlanPage(planDetails: _generatedIdea),
                        ),
                      );
                    },
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
                        borderRadius: BorderRadius.circular(8.0),
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
