import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/task.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8080";

  static Map<String, String> _buildHeaders(String? token) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<Map<String, dynamic>> fetchTasks(String? token) async {
    final headers = _buildHeaders(token);

    final url = Uri.parse('$baseUrl/tasks');
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      final tasks = data.map((json) => Task.fromJson(json)).toList();
      final newToken = response.headers['authorization']?.replaceFirst(
        'Bearer ',
        '',
      );
      return {'tasks': tasks, 'token': newToken};
    } else {
      throw Exception('Failed to fetch tasks');
    }
  }

  static Future<Task?> addTask(Task task, String? token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tasks'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'title': task.title, 'description': task.description}),
    );

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return Task.fromJson(json['data']);
    } else {
      throw Exception('Failed to add task');
    }
  }

  static Future<Task?> getTask(int id, String? token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/tasks/$id'),
      headers: _buildHeaders(token),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body)['data'];
      return Task.fromJson(json);
    }
    return null;
  }

  static Future<String?> deleteTask(int id, String? token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/tasks/$id'),
      headers: _buildHeaders(token),
    );

    if (response.statusCode == 204 || response.statusCode == 200) {
      return response.headers['authorization']?.replaceFirst('Bearer ', '');
    }
    throw Exception('Failed to delete task');
  }

  static Future<String?> updateTask(Task task, String? token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/tasks/${task.id}'),
      headers: _buildHeaders(token),
      body: jsonEncode(task.toJson()),
    );

    if (response.statusCode == 200) {
      return response.headers['authorization']?.replaceFirst('Bearer ', '');
    }
    throw Exception('Failed to update task');
  }
}
