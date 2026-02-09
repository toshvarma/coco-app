import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  //static const String _baseUrl = 'http://10.0.2.2:3000/api/auth';
  //static const String _baseUrl = 'http://localhost:3000/api/auth';
static const String _baseUrl = 'http://10.19.79.35:3000/api/auth';
  
  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          // Save user info locally
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('userEmail', data['user']['email']);
          await prefs.setString('userName', data['user']['name']);

          return data['user'];
        }
      }
      return null;
    } catch (e) {
      print('Error logging in: $e');
      return null;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userEmail');
    await prefs.remove('userName');
  }

  Future<Map<String, String>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('userEmail');
    final name = prefs.getString('userName');

    if (email != null && name != null) {
      return {'email': email, 'name': name};
    }
    return null;
  }

  Future<bool> isLoggedIn() async {
    final user = await getCurrentUser();
    return user != null;
  }
}