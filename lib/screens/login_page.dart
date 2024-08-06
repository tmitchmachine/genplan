import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

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
        backgroundColor: Colors.transparent,
        body: buildLoginPageUI(buttonWidth),
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
            _loginBtn(buttonWidth),
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
        textAlign: TextAlign.center, // Center the hint text
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

  Widget _loginBtn(double width) {
    return Container(
      width: width,
      child: ElevatedButton(
        onPressed: () {
          debugPrint("Email : " + emailController.text);
        },
        child: Text(
          "Continue",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15),
        ),
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          backgroundColor: Color.fromARGB(225, 228, 226, 226),
          foregroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
        ),
      ),
    );
  }
}
