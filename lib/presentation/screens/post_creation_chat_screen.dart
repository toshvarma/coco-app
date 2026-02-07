import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/colors.dart';
import '../../data/services/ai_chat_service.dart';
import '../../domain/models/chat_message_model.dart';

class PostCreationChatScreen extends StatefulWidget {
  final String occasion;
  final String platform;
  final String description;
  final List<ChatMessage> initialMessages;

  const PostCreationChatScreen({
    super.key,
    required this.occasion,
    required this.platform,
    required this.description,
    required this.initialMessages,
  });

  @override
  State<PostCreationChatScreen> createState() => _PostCreationChatScreenState();
}

class _PostCreationChatScreenState extends State<PostCreationChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late List<ChatMessage> _messages;
  final AiChatService _aiService = AiChatService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Start with AI's response (hide the user's context message)
    _messages = [
      ChatMessage(
        id: 'welcome',
        content: "Hi Lena! I'm ready to help you create an amazing ${widget.occasion.toLowerCase()} for ${widget.platform}. ${widget.initialMessages.last.content}",
        isUser: false,
        timestamp: DateTime.now(),
      ),
    ];

    // Scroll to bottom after build
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
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
      // Build chat history including the hidden context
      final chatHistory = [
        // Include the original context from questionnaire
        ...widget.initialMessages.map((msg) => msg.toApiFormat()),
        // Add visible conversation
        ..._messages.skip(1).map((msg) => msg.toApiFormat()),
      ];

      final response = await _aiService.sendMessage(
        userMessage,
        chatHistory: chatHistory,
      );

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
          content: "Sorry, I encountered an error. Please try again.",
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

  void _copyMessage(String content) {
    Clipboard.setData(ClipboardData(text: content));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('AI Content Creator'),
            Text(
              '${widget.platform} • ${widget.occasion}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        backgroundColor: AppColors.primarygreen,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showProjectInfo();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Context banner
          _buildContextBanner(),

          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _ChatBubble(
                  message: message,
                  onCopy: () => _copyMessage(message.content),
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
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primarygreen),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'AI is creating...',
                    style: TextStyle(
                      color: AppColors.primarygreen,
                      fontSize: 13,
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

  Widget _buildContextBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primarygreen.withOpacity(0.1),
            AppColors.lightGreen.withOpacity(0.1),
          ],
        ),
        border: Border(
          bottom: BorderSide(color: AppColors.primarygreen.withOpacity(0.2)),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline, size: 16, color: AppColors.primarygreen),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Tip: Ask AI to refine, shorten, or add emojis to any suggestion',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
                hintText: 'Ask AI to refine or suggest...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: AppColors.lightGreen),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: AppColors.lightGreen),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: AppColors.primarygreen, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                filled: true,
                fillColor: AppColors.background,
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
                colors: [AppColors.primarygreen, AppColors.primarygreen],
              ),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send_rounded, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  void _showProjectInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Project Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Occasion:', widget.occasion),
            const SizedBox(height: 8),
            _buildInfoRow('Platform:', widget.platform),
            const SizedBox(height: 8),
            _buildInfoRow('Description:', widget.description),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14),
        ),
      ],
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
            color: message.isUser ? AppColors.primarygreen : Colors.white,
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
              Text(
                message.content,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black87,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
              if (!message.isUser)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Long press to copy',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[500],
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