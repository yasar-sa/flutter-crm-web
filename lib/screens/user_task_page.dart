import 'package:flutter/material.dart';

class UserTaskPage extends StatelessWidget {
  const UserTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Text(
          'Staff: View My Assigned Tasks',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
