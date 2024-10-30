import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';

class ApiService {
  static const String baseUrl = 'https://reqres.in/api';
  
  Future<List<User>> getUsers(int page, int perPage) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/users?page=$page&per_page=$perPage'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> userJson = data['data'];
        return userJson.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<User?> getUserById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/users/$id'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return User.fromJson(data['data']);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}