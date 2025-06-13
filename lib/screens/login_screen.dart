import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main_page.dart'; // Import the dummy main page
import 'forgot_password_screen.dart'; // Adjust according to your file structure

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate a network call or authentication process
    //await Future.delayed(Duration(seconds: 2));

    // Hardcoded credentials for demonstration
    const String validMobile = "";
    const String validPassword = "";

    if (_mobileController.text == validMobile &&
        _passwordController.text == validPassword) {
      // Navigate to the main page if credentials are correct
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    } else {
      // Show an error message if credentials are incorrect
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid mobile number or password'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              Text(
                'Login',
                style: GoogleFonts.poppins(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fadeIn(duration: 500.ms),
              SizedBox(height: 40),
              TextField(
                controller: _mobileController,
                decoration: InputDecoration(
                  labelText: 'Enter your Mobile Number',
                  border: OutlineInputBorder(),
                ),
              ).animate().slideX(duration: 500.ms),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Enter your Password',
                  border: OutlineInputBorder(),
                ),
              ).animate().slideX(duration: 600.ms),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgotPasswordScreen()),
                  );
                },
                child: Text('Forgot password?'),
              ).animate().fadeIn(duration: 700.ms),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  minimumSize:
                      const Size(double.infinity, 50), // Full width, 50 height
                  textStyle: const TextStyle(
                    fontSize: 20, // Increased font size
                    fontWeight: FontWeight.bold, // Make text bold
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Login'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
