import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/scheduled_post_model.dart';

class ScheduleService {
  // USE ONE OF THESE THREE PORTS TO RUN ON EMULATOR, WEB BROWSER, OR ANDROID DEVICE
  //static const String _baseUrl = 'http://10.0.2.2:3000/api/posts';
  //static const String _baseUrl = 'http://localhost:3000/api/posts';
  static const String _baseUrl = 'http://10.19.79.35:3000/api/posts';

  Future<String> _getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail') ?? '';
  }


  Future<bool> schedulePost(ScheduledPost post) async {
    try {
      final userEmail = await _getUserEmail();

      final response = await http.post(
        Uri.parse('$_baseUrl/schedule'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userEmail': userEmail,
          'post': post.toJson(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] ?? false;
      }
      return false;
    } catch (e) {
      print('Error scheduling post: $e');
      return false;
    }
  }


  Future<List<ScheduledPost>> getAllScheduledPosts() async {
    try {
      final userEmail = await _getUserEmail();

      final response = await http.get(
        Uri.parse('$_baseUrl/scheduled/$userEmail'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          final List posts = data['posts'];
          return posts.map((json) => ScheduledPost.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching posts: $e');
      return [];
    }
  }


  Future<bool> deletePost(String postId) async {
    try {
      final userEmail = await _getUserEmail();

      final response = await http.delete(
        Uri.parse('$_baseUrl/scheduled/$userEmail/$postId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] ?? false;
      }
      return false;
    } catch (e) {
      print('Error deleting post: $e');
      return false;
    }
  }
}