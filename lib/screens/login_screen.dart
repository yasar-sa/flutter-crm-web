import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main_page.dart';
import 'forgot_password_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/shared_preference_helper.dart';

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

    final response = await http
        .get(Uri.parse('https://real-pro-service.onrender.com/api/users'));

    if (response.statusCode == 200) {
      final users = json.decode(response.body);
      final user = users.firstWhere(
        (u) =>
            u['username'] == _mobileController.text &&
            u['password'] == _passwordController.text,
        orElse: () => null,
      );

      if (user != null) {
        await SharedPreferenceHelper.setRole(user['role']);
        await SharedPreferenceHelper.setUsername(user['username']);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      } else {
        _showError();
      }
    } else {
      _showError();
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Invalid username or password'),
          backgroundColor: Colors.red),
    );
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
              const SizedBox(height: 100),
              Text(
                'Login',
                style: GoogleFonts.poppins(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fadeIn(duration: 500.ms),
              const SizedBox(height: 40),
              TextField(
                controller: _mobileController,
                decoration: const InputDecoration(
                  labelText: 'Enter your Username',
                  border: OutlineInputBorder(),
                ),
              ).animate().slideX(duration: 500.ms),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Enter your Password',
                  border: OutlineInputBorder(),
                ),
              ).animate().slideX(duration: 600.ms),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgotPasswordScreen()),
                  );
                },
                child: const Text('Forgot password?'),
              ).animate().fadeIn(duration: 700.ms),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  minimumSize: const Size(double.infinity, 50),
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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
