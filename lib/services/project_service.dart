import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/project_analytics_model.dart';

class ProjectService {
  static const String apiUrl =
      'https://real-pro-service.onrender.com/api/projects';

  static Future<List<ProjectAnalytics>> fetchProjectAnalytics() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data
            .map((project) => ProjectAnalytics.fromJson(project))
            .toList();
      } else {
        throw Exception('Failed to load projects');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
}
