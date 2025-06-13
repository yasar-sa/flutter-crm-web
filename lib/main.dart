import 'package:flutter/material.dart';
import 'package:flutter_crm/screens/login_screen.dart';
// import 'package:flutter_crm/screens/login_screen.dart';
import 'package:flutter_crm/screens/main_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login UI App',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Main theme color
        scaffoldBackgroundColor: Colors.white, // Background color
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue, // AppBar background
          iconTheme: IconThemeData(color: Colors.black), // AppBar icons
          titleTextStyle: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, // Default button color
            foregroundColor: Colors.black, // Button text color
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black), // Default text color
          bodyMedium: TextStyle(color: Colors.black),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.blue, // Override any purple accents
          primary: Colors.blue,
        ),
        useMaterial3:
            false, // Ensures Material 2 (removes Material 3’s purple accents)
      ),
      home: LoginScreen(),
    );
  }
}
