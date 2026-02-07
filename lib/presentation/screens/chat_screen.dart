import 'package:flutter/material.dart';
import '../../data/services/ai_chat_service.dart';
import '../../domain/models/chat_message_model.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  final AiChatService _aiService = AiChatService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Add welcome message
    _messages.add(ChatMessage(
      id: DateTime.now().toString(),
      content: "Hi Lena! I'm COCO, your AI social media assistant. How can I help you create amazing content today?",
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = _messageController.text.trim();
    _messageController.clear();

    setState(() {
      _messages.add(ChatMessage(
        id: DateTime.now().toString(),
        content: userMessage,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
    });

    _scrollToBottom();

    try {
      final chatHistory = _messages
          .skip(1)
          .map((msg) => msg.toApiFormat())
          .toList();

      final response = await _aiService.sendMessage(userMessage, chatHistory: chatHistory);

      setState(() {
        _messages.add(ChatMessage(
          id: DateTime.now().toString(),
          content: response,
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isLoading = false;
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          id: DateTime.now().toString(),
          content: "Sorry, I encountered an error. Please make sure the backend server is running and try again.",
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text('AI Chat Assistant'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _ChatBubble(
                  message: message,
                  onCopy: () {},
                );
              },
            ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'COCO is typing...',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Ask me anything...',
                hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.5)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: colorScheme.outline),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: colorScheme.outline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                filled: true,
                fillColor: colorScheme.background,
              ),
              onSubmitted: (_) => _sendMessage(),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colorScheme.primary, colorScheme.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.send_rounded, color: colorScheme.onPrimary),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final VoidCallback onCopy;

  const _ChatBubble({
    required this.message,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: message.isUser ? null : onCopy,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: message.isUser ? colorScheme.primaryContainer : colorScheme.surface,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
              bottomLeft: message.isUser ? const Radius.circular(20) : const Radius.circular(4),
              bottomRight: message.isUser ? const Radius.circular(4) : const Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message.isUser)
                Text(
                  message.content,
                  style: TextStyle(
                    color: colorScheme.onPrimaryContainer,
                    fontSize: 15,
                    height: 1.4,
                  ),
                )
              else
                MarkdownBody(
                  data: message.content,
                  styleSheet: MarkdownStyleSheet(
                    p: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 15,
                      height: 1.4,
                    ),
                    strong: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                    em: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: colorScheme.onSurface,
                    ),
                    listBullet: TextStyle(
                      color: colorScheme.primary,
                      fontSize: 15,
                    ),
                    code: TextStyle(
                      backgroundColor: colorScheme.background,
                      color: colorScheme.primary,
                      fontFamily: 'monospace',
                    ),
                    h1: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                    h2: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                    h3: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                    blockquote: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.7),
                      fontStyle: FontStyle.italic,
                    ),
                    blockquoteDecoration: BoxDecoration(
                      color: colorScheme.background,
                      borderRadius: BorderRadius.circular(4),
                      border: Border(
                        left: BorderSide(
                          color: colorScheme.primary,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                  selectable: true,
                ),
              if (!message.isUser)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Long press to copy',
                    style: TextStyle(
                      fontSize: 10,
                      color: colorScheme.onSurface.withOpacity(0.5),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}