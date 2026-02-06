class ChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
  });

  Map<String, String> toApiFormat() {
    return {
      'role': isUser ? 'user' : 'assistant',
      'content': content,
    };
  }
}