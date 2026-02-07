import 'dart:convert';
import 'package:http/http.dart' as http;

class AiChatService {
  static const String _baseUrl = 'http://10.0.2.2:3000/api/chat';
  //static const String _baseUrl = 'http://localhost:3000/api/chat';

  Future<String> sendMessage(
      String userMessage, {
        List<Map<String, String>>? chatHistory,
      }) async {
    try {
      List<Map<String, String>> messages = [];

      if (chatHistory != null) {
        messages.addAll(chatHistory);
      }

      messages.add({
        'role': 'user',
        'content': userMessage,
      });

      print('Sending request to backend...');

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'messages': messages,
          'system': 'You are COCO, a helpful AI assistant for social media content creation. You help interior designers create engaging posts for Instagram, Facebook, LinkedIn, and TikTok. Be creative, professional, and concise.',
        }),
      );

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['content'][0]['text'];
      } else {
        final error = jsonDecode(response.body);
        throw Exception('API Error: ${error['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      print('Error in AI service: $e');
      throw Exception('Error communicating with AI: $e');
    }
  }
}