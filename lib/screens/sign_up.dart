import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // For storing additional user data
import 'home.dart'; // Ensure HomePage is defined in this file
import 'login.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> signUpWithEmail() async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Store additional user info like username
      if (userCredential.user != null) {
        await firestore.collection('users').doc(userCredential.user!.uid).set({
          'username': usernameController.text.trim(),
          'email': emailController.text.trim(),
        });

        // Navigate to Home Page
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
    } catch (e) {
      print("Error $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign up: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double buttonWidth =
        MediaQuery.of(context).size.width - 64; // Subtract padding

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF8EA7FA), Color(0xFF0969D4)],
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Sign Up', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          leading: null, // Remove the back arrow
          automaticallyImplyLeading: false,
        ),
        backgroundColor: Colors.transparent,
        body: buildSignupPageUI(buttonWidth),
      ),
    );
  }

  Widget buildSignupPageUI(double buttonWidth) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _icon(),
              const SizedBox(height: 50.0),
              _inputField("Enter Username", usernameController, buttonWidth),
              const SizedBox(height: 30.0),
              _inputField("Enter Email", emailController, buttonWidth,
                  isEmail: true),
              const SizedBox(height: 30.0),
              _inputField("Enter Password", passwordController, buttonWidth,
                  isPassword: true),
              const SizedBox(height: 30.0),
              _signupBtn(buttonWidth),
              const SizedBox(height: 30.0),
              _signupLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _icon() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.app_registration_rounded,
          color: Colors.white, size: 120),
    );
  }

  Widget _inputField(
      String hintText, TextEditingController controller, double width,
      {bool isPassword = false, bool isEmail = false}) {
    return Container(
      width: width,
      child: TextField(
        style: const TextStyle(color: Colors.white),
        controller: controller,
        textAlign: TextAlign.center,
        // Center the hint text
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.white),
          ),
        ),
        obscureText: isPassword,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      ),
    );
  }

  Widget _signupBtn(double width) {
    return Container(
      width: width,
      child: ElevatedButton(
        onPressed: () {
          signUpWithEmail();
        },
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          backgroundColor: Color.fromARGB(225, 228, 226, 226),
          foregroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
        ),
        child: const Text(
          "Sign Up",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  Widget _signupLink() {
    return TextButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LoginPage(), // Navigate to the login page
          ),
        );
      },
      child: const Text(
        "Already have an account? Login",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
