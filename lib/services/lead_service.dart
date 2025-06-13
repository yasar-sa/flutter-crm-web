import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/lead_model.dart';

class LeadService {
  final String apiUrl = 'https://real-pro-service.onrender.com/api/leads';

  Future<List<Lead>> fetchLeads() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((lead) => Lead.fromJson(lead)).toList();
    } else {
      throw Exception('Failed to load leads');
    }
  }
}
