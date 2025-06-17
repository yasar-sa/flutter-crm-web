///crud operation need to be done
///for now add only done
///set time limits

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';

class AdminTaskPage extends StatefulWidget {
  @override
  _AdminTaskPageState createState() => _AdminTaskPageState();
}

class _AdminTaskPageState extends State<AdminTaskPage> {
  List<Task> _tasks = [];
  bool _isLoading = true;
  final _formKey = GlobalKey<FormState>();
  String _description = '';
  String _owner = '';
  String _status = 'pending';
  String _initialComment = '';

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      final tasks = await TaskService.fetchTasks();
      setState(() {
        _tasks = tasks;
        _isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _createTask() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final taskData = {
        'description': _description,
        'owner': _owner,
        'status': _status,
        'comments': _initialComment.isNotEmpty
            ? [
                {
                  'comment': _initialComment,
                  'commenter': 'admin',
                  'timestamp': DateTime.now().toIso8601String(),
                }
              ]
            : []
      };

      await TaskService.createTask(taskData);
      _loadTasks();
      Navigator.pop(context);
    }
  }

  void _showCreateTaskDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Assign New Task'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Task Description'),
                onSaved: (value) => _description = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Enter description' : null,
              ),
              FutureBuilder<List<String>>(
                future: TaskService.fetchStaffUsers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Failed to load users');
                  } else {
                    final users = snapshot.data!;
                    return DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Assign To'),
                      items: users.map((username) {
                        return DropdownMenuItem<String>(
                          value: username,
                          child: Text(username),
                        );
                      }).toList(),
                      onChanged: (value) {
                        _owner = value!;
                      },
                      validator: (value) => value == null || value.isEmpty
                          ? 'Select a user'
                          : null,
                    );
                  }
                },
              ),
              DropdownButtonFormField<String>(
                value: _status,
                items: ['pending', 'in_progress', 'completed']
                    .map((status) =>
                        DropdownMenuItem(value: status, child: Text(status)))
                    .toList(),
                onChanged: (value) => _status = value!,
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Initial Comment (optional)'),
                onSaved: (value) => _initialComment = value ?? '',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(onPressed: _createTask, child: Text('Create')),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Task task, int index) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 500),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Card(
            color: Colors.white,
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.description,
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.person, size: 18, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(task.owner),
                      const Spacer(),
                      Chip(
                        label: Text(task.status.toUpperCase(),
                            style: const TextStyle(color: Colors.white)),
                        backgroundColor: task.status == 'pending'
                            ? Colors.orange
                            : task.status == 'in_progress'
                                ? Colors.blue
                                : Colors.green,
                      ),
                    ],
                  ),
                  if (task.comments.isNotEmpty) ...[
                    const Divider(),
                    Text("Comments:",
                        style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                    ...task.comments.map(
                      (c) => ListTile(
                        leading: const Icon(Icons.comment,
                            color: Colors.deepPurpleAccent),
                        title: Text(c.comment),
                        subtitle: Text('${c.commenter} • ${c.timestamp}'),
                        contentPadding: const EdgeInsets.only(left: 0),
                      ),
                    )
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Task Manager',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: const Color(0xFFF1F4FB),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : AnimationLimiter(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (_, index) => _buildTaskCard(_tasks[index], index),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateTaskDialog,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
    );
  }
}
