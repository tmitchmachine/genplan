import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:genplan/screens/sign_up.dart'; // Ensure this path is correct
import 'package:genplan/screens/home.dart';
import 'package:genplan/screens/forgot_password.dart'; // Add this import statement

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  Future<void> signInWithEmail() async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      // Navigate to Home Screen if sign-in is successful
      if (userCredential.user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
    } catch (e) {
      // Handle errors like wrong password or user not found
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in: $e')),
      );
    }
  }

  Future<void> resetPassword() async {
    if (emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your email address.')),
      );
      return;
    }

    try {
      await auth.sendPasswordResetEmail(email: emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset email sent!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send password reset email: $e')),
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
          leading: Container(),
          backgroundColor: Colors.transparent,
          title: const Text('Login', style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(child: buildLoginPageUI(buttonWidth)),
      ),
    );
  }

  Widget buildLoginPageUI(double buttonWidth) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _icon(),
            const SizedBox(height: 50.0),
            _inputField("Enter Email", emailController, buttonWidth,
                isEmail: true),
            const SizedBox(height: 30.0),
            _inputField("Enter Password", passwordController, buttonWidth,
                isPassword: true),
            const SizedBox(height: 10.0),
            _forgotPasswordLink(),
            const SizedBox(height: 30.0),
            _loginBtn(buttonWidth),
            const SizedBox(height: 30.0),
            _signupLink(),
          ],
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
      child: const Icon(Icons.person, color: Colors.white, size: 120),
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

  Widget _forgotPasswordLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ForgotPasswordPage(), // Updated navigation
            ),
          );
        },
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _loginBtn(double width) {
    return Container(
      width: width,
      child: ElevatedButton(
        onPressed: () {
          signInWithEmail();
        },
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          backgroundColor: const Color.fromARGB(225, 228, 226, 226),
          foregroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
        ),
        child: const Text(
          "Continue",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  Widget _signupLink() {
    return TextButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                SignupPage(), // Correct navigation to SignupPage
          ),
        );
      },
      child: const Text(
        "Don't have an account? Sign up",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
