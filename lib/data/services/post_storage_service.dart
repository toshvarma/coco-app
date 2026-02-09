import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coco_app/domain/models/scheduled_post_model.dart';

class PostStorageService {
  static const String _postsKey = 'scheduled_posts';


  Future<List<ScheduledPost>> getAllPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? postsJson = prefs.getString(_postsKey);

    if (postsJson == null) {

      return _getMockData();
    }

    final List<dynamic> decoded = json.decode(postsJson);
    return decoded.map((item) => ScheduledPost.fromJson(item)).toList();
  }


  Future<List<ScheduledPost>> getPostsForDate(DateTime date) async {
    final allPosts = await getAllPosts();
    return allPosts.where((post) {
      return post.date.year == date.year &&
          post.date.month == date.month &&
          post.date.day == date.day;
    }).toList();
  }


  Future<Map<int, List<ScheduledPost>>> getPostsForMonth(int year, int month) async {
    final allPosts = await getAllPosts();
    final Map<int, List<ScheduledPost>> postsMap = {};

    for (var post in allPosts) {
      if (post.date.year == year && post.date.month == month) {
        final day = post.date.day;
        if (!postsMap.containsKey(day)) {
          postsMap[day] = [];
        }
        postsMap[day]!.add(post);
      }
    }

    return postsMap;
  }


  Future<void> addPost(ScheduledPost post) async {
    final allPosts = await getAllPosts();
    allPosts.add(post);
    await _savePosts(allPosts);
  }


  Future<void> updatePost(ScheduledPost post) async {
    final allPosts = await getAllPosts();
    final index = allPosts.indexWhere((p) => p.id == post.id);

    if (index != -1) {
      allPosts[index] = post;
      await _savePosts(allPosts);
    }
  }


  Future<void> deletePost(String postId) async {
    final allPosts = await getAllPosts();
    allPosts.removeWhere((post) => post.id == postId);
    await _savePosts(allPosts);
  }


  Future<void> _savePosts(List<ScheduledPost> posts) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(posts.map((p) => p.toJson()).toList());
    await prefs.setString(_postsKey, encoded);
  }


  List<ScheduledPost> _getMockData() {
    return [
      ScheduledPost(
        id: '1',
        platform: 'Instagram',
        topic: 'New Year, New Space mood board',
        date: DateTime(2026, 1, 3),
        time: '10:00',
      ),
      ScheduledPost(
        id: '2',
        platform: 'Facebook',
        topic: 'Repost of Jan 3',
        note: 'No notes',
        date: DateTime(2026, 1, 6),
        time: '14:00',
      ),
      ScheduledPost(
        id: '3',
        platform: 'Instagram',
        topic: 'Living room before/after carousel',
        note: 'Client approved sharing photos',
        date: DateTime(2026, 1, 9),
        time: '11:30',
      ),
      ScheduledPost(
        id: '4',
        platform: 'LinkedIn',
        topic: 'What interior design taught me about project management',
        date: DateTime(2026, 1, 13),
        time: '09:00',
      ),
      ScheduledPost(
        id: '5',
        platform: 'Instagram',
        topic: 'Material spotlight: natural stone',
        note: 'Use softer tone, less technical',
        date: DateTime(2026, 1, 16),
        time: '15:00',
      ),
      ScheduledPost(
        id: '6',
        platform: 'Facebook',
        topic: 'Client testimonial (text-heavy)',
        date: DateTime(2026, 1, 20),
        time: '12:00',
      ),
      ScheduledPost(
        id: '7',
        platform: 'Instagram',
        topic: 'Lighting mistakes in small apartments',
        date: DateTime(2026, 1, 24),
        time: '16:00',
      ),
      ScheduledPost(
        id: '8',
        platform: 'Instagram',
        topic: 'Post about eco-friendly materials. Add example from recent project.',
        note: 'Draft - needs final review',
        isDraft: true,
        date: DateTime(2026, 1, 31),
        time: '10:00',
      ),
    ];
  }
}