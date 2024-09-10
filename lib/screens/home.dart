import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
              child: const Text(
                'Idea Placeholder',
                style: TextStyle(fontSize: 22),
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
                    onTap: () {
                      setState(() {
                        _isThumbsUpSelected = !_isThumbsUpSelected;
                        _isThumbsDownSelected =
                            false; // Reset thumbs down when thumbs up is selected
                      });
                    },
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
                          builder: (context) => PlanPage(),
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
                    onTap: () {
                      setState(() {
                        _isThumbsDownSelected = !_isThumbsDownSelected;
                        _isThumbsUpSelected =
                            false; // Reset thumbs up when thumbs down is selected
                      });
                    },
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
