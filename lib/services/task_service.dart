import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task_model.dart';

class TaskService {
  static const String baseUrl =
      'https://real-pro-service.onrender.com/api/tasks';

  static Future<void> addOrUpdateComment(
      String taskId, Map<String, dynamic> commentData) async {
    final url = Uri.parse('$baseUrl/tasks/$taskId/comments');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(commentData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update/add comment');
    }
  }

  static Future<List<Task>> fetchTasks({String? owner}) async {
    final url = owner != null ? '$baseUrl?owner=$owner' : baseUrl;
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Task.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  // static Future<void> createTask(Map<String, dynamic> body) async {
  //   final response = await http.post(
  //     Uri.parse(baseUrl),
  //     headers: {'Content-Type': 'application/json'},
  //     body: json.encode(body),
  //   );

  //   if (response.statusCode != 201) {
  //     throw Exception('Failed to create task');
  //   }
  // }

  static Future<void> createTask(Map<String, dynamic> body) async {
    print('📤 Sending task data: $body'); // <-- Debug print

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    print('📥 Status code: ${response.statusCode}');
    print('📥 Response body: ${response.body}');

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to create task');
    }
  }

  static Future<List<String>> fetchStaffUsers() async {
    final response = await http.get(
      Uri.parse('https://real-pro-service.onrender.com/api/users'),
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data
          .where((user) =>
              user['role'] == 'ROLE_STAFF' && user['approved'] == true)
          .map<String>((user) => user['username'].toString())
          .toList();
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  static Future<void> updateTask(
      String taskId, Map<String, dynamic> updatedData) async {
    final url = Uri.parse(
        'https://real-pro-service.onrender.com/api/tasks/$taskId'); // adjust endpoint if needed
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update task: ${response.body}');
    }
  }
}
