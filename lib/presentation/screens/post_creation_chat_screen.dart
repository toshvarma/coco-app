import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../data/services/ai_chat_service.dart';
import '../../data/services/auth_service.dart';
import '../../domain/models/chat_message_model.dart';
import 'template_selection_screen.dart';
import 'home_screen.dart';

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
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final user = await _authService.getCurrentUser();
    if (user != null && mounted) {
      setState(() {
        _userName = user['name']?.split(' ').first ?? 'there';
        _messages = [
          ChatMessage(
            id: 'welcome',
            content: "Hi $_userName! I'm ready to help you create an amazing ${widget.occasion.toLowerCase()} for ${widget.platform}. ${widget.initialMessages.last.content}",
            isUser: false,
            timestamp: DateTime.now(),
          ),
        ];
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
  }

  void _navigateToTemplates() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TemplateSelectionScreen(
          platform: widget.platform,
          occasion: widget.occasion,
          chatHistory: _messages,
        ),
      ),
    );
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
      final chatHistory = [
        ...widget.initialMessages.map((msg) => msg.toApiFormat()),
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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: colorScheme.onPrimary),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => false,
            );
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI Content Creator',
              style: TextStyle(color: colorScheme.onPrimary),
            ),
            Text(
              '${widget.platform} • ${widget.occasion}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: colorScheme.onPrimary.withOpacity(0.9),
              ),
            ),
          ],
        ),
        backgroundColor: colorScheme.primaryContainer,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '1/2',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildContextBanner(),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];

                int? aiMessageNumber;
                if (!message.isUser) {
                  aiMessageNumber = _messages
                      .take(index + 1)
                      .where((m) => !m.isUser)
                      .length;
                }

                return _ChatBubble(
                  message: message,
                  onCopy: () => _copyMessage(message.content),
                  messageNumber: aiMessageNumber,
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
                      valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'AI is creating...',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                top: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: _navigateToTemplates,
                icon: Icon(Icons.dashboard_customize, color: colorScheme.primary, size: 20),
                label: Text(
                  'Choose Template',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: colorScheme.primary, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),

          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildContextBanner() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer.withOpacity(0.1),
            colorScheme.secondaryContainer.withOpacity(0.1),
          ],
        ),
        border: Border(
          bottom: BorderSide(color: colorScheme.primary.withOpacity(0.2)),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline, size: 16, color: colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Tip: Ask AI to refine, shorten, or add emojis to any suggestion',
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
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
                hintText: 'Ask AI to refine or suggest...',
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
  final int? messageNumber;

  const _ChatBubble({
    required this.message,
    required this.onCopy,
    this.messageNumber,
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
              if (!message.isUser && messageNumber != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        size: 12,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'COCOs Response #$messageNumber',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],

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