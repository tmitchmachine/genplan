import 'package:flutter/material.dart';

class SignInOptionsPage extends StatelessWidget {
  const SignInOptionsPage({Key? key}) : super(key: key);

  Widget _loginButton(double width, BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/login'); // Navigate to LoginPage
        },
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          backgroundColor: Colors.transparent, // Set background to transparent
          foregroundColor: Colors.white, // Text color to white
          side:
              const BorderSide(color: Colors.white, width: 2.0), // White border
          padding: const EdgeInsets.symmetric(vertical: 16.0),
        ),
        child: const Text(
          "Login",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  Widget _signupButton(double width, BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/signup'); // Navigate to SignupPage
        },
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          backgroundColor: Colors.white, // Set background to solid white
          foregroundColor: Colors.blue, // Text color to blue
          padding: const EdgeInsets.symmetric(vertical: 16.0),
        ),
        child: const Text(
          "Signup",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double buttonWidth = MediaQuery.of(context).size.width - 64;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF8EA7FA), Color(0xFF0969D4)],
        ),
      ),
      child: Scaffold(
        backgroundColor:
            Colors.transparent, // Set background transparent to show gradient
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                '/Users/heavenya/Github/genplan/assets/icon/icon.png',
                width: 100, // Set the desired width of the image
                height: 100, // Set the desired height of the image
              ),
              const SizedBox(height: 50.0), // Space between image and buttons
              _loginButton(buttonWidth, context),
              const SizedBox(height: 30.0),
              _signupButton(buttonWidth, context),
            ],
          ),
        ),
      ),
    );
  }
}
