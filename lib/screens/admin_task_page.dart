import 'package:flutter/material.dart';

class AdminTaskPage extends StatelessWidget {
  const AdminTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Task Management'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Text(
          'Admin: View & Assign Tasks',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
