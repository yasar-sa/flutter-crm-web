/// edit comment is not yet finished it has some bugs
/// if we login with user1 he gets all the tasks for the user2 also. need to fix that too
/// mark as completed should be added
/// task should be finished once the user selects mark as completed

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';

class UserTaskPage extends StatefulWidget {
  @override
  _UserTaskPageState createState() => _UserTaskPageState();
}

class _UserTaskPageState extends State<UserTaskPage> {
  List<Task> _myTasks = [];
  bool _isLoading = true;
  String _userEmail = '';
  String _selectedStatus = 'all';

  @override
  void initState() {
    super.initState();
    _loadUserTasks();
  }

  Future<void> _loadUserTasks() async {
    final prefs = await SharedPreferences.getInstance();
    _userEmail = prefs.getString('email') ?? '';

    try {
      final tasks = await TaskService.fetchTasks(owner: _userEmail);
      setState(() {
        _myTasks = tasks;
        _isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void _editComment(Task task) async {
    String? newComment = await showDialog(
      context: context,
      builder: (context) {
        String updatedComment =
            task.comments.isNotEmpty ? task.comments.first.comment : '';
        return AlertDialog(
          title: Text('Edit Comment'),
          content: TextField(
            controller: TextEditingController(text: updatedComment),
            onChanged: (value) => updatedComment = value,
            decoration: InputDecoration(labelText: 'Comment'),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text('Cancel')),
            ElevatedButton(
                onPressed: () => Navigator.pop(context, updatedComment),
                child: Text('Save')),
          ],
        );
      },
    );

    if (newComment != null && newComment.trim().isNotEmpty) {
      final commentData = {
        'comment': newComment.trim(),
        'commenter': 'user', // or get from SharedPreferences
        'timestamp': DateTime.now().toIso8601String(),
      };

      try {
        await TaskService.addOrUpdateComment(task.id, commentData);
        await _loadUserTasks(); // Refresh task list
      } catch (e) {
        print('Error updating comment: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update comment')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredTasks = _selectedStatus == 'all'
        ? _myTasks
        : _myTasks.where((task) => task.status == _selectedStatus).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('My Tasks', style: GoogleFonts.poppins()),
        actions: [
          DropdownButton<String>(
            value: _selectedStatus,
            dropdownColor: isDark ? Colors.grey[900] : Colors.white,
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
            underline: SizedBox(),
            items: ['all', 'pending', 'in_progress', 'completed']
                .map((status) => DropdownMenuItem(
                      value: status,
                      child: Text(status.replaceAll('_', ' ').toUpperCase()),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() => _selectedStatus = value!);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadUserTasks,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : filteredTasks.isEmpty
                ? Center(
                    child: Text('No tasks available.',
                        style: GoogleFonts.poppins()))
                : AnimationLimiter(
                    child: ListView.builder(
                      padding: EdgeInsets.all(12),
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];
                        final comment = task.comments.isNotEmpty
                            ? task.comments.first.comment
                            : 'No comment yet';
                        final statusColor = {
                              'pending': Colors.orange,
                              'in_progress': Colors.blue,
                              'completed': Colors.green
                            }[task.status] ??
                            Colors.grey;

                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: Duration(milliseconds: 500),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: Card(
                                color: isDark ? Colors.grey[850] : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 6,
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            task.description,
                                            style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Chip(
                                            label: Text(
                                              task.status.replaceAll('_', ' '),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            backgroundColor: statusColor,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Text('Comment: $comment',
                                          style: GoogleFonts.poppins()),
                                      SizedBox(height: 6),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton.icon(
                                          icon: Icon(Icons.edit),
                                          label: Text('Edit Comment'),
                                          onPressed: () => _editComment(task),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
