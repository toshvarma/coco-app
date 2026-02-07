import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/models/scheduled_post_model.dart';

class ScheduleService {
  static const String _baseUrl = 'http://10.0.2.2:3000/api/posts'; // Change for mobile: http://10.0.2.2:3000/api/posts

  // Schedule a post
  Future<bool> schedulePost(ScheduledPost post) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/schedule'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(post.toJson()),
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

  // Get all scheduled posts
  Future<List<ScheduledPost>> getAllScheduledPosts() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/scheduled'),
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

  // Delete a post
  Future<bool> deletePost(String postId) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/scheduled/$postId'),
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