import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../data/services/ai_chat_service.dart';
import '../../domain/models/chat_message_model.dart';
import 'post_creation_chat_screen.dart';
import 'home_screen.dart';

class PostQuestionnaireScreen extends StatefulWidget {
  const PostQuestionnaireScreen({super.key});

  @override
  State<PostQuestionnaireScreen> createState() => _PostQuestionnaireScreenState();
}

class _PostQuestionnaireScreenState extends State<PostQuestionnaireScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  String _selectedOccasion = 'Product Launch';
  String _selectedPlatform = 'Instagram';
  final TextEditingController _descriptionController = TextEditingController();

  bool _isLoading = false;

  // Occasion options
  final List<String> _occasions = [
    'Product Launch',
    'Project Showcase',
    'Behind the Scenes',
    'Client Testimonial',
    'Tips & Advice',
    'Seasonal Content',
    'Event Announcement',
    'Other',
  ];

  // Platform options
  final List<String> _platforms = [
    'Instagram',
    'Facebook',
    'LinkedIn',
    'TikTok',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => false,
            );
          },
        ),
        title: const Text('Create New Post'),
        backgroundColor: AppColors.primarygreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome header
              _buildHeader(),
              const SizedBox(height: 32),

              // Question 1: Occasion
              _buildSectionTitle('1. What\'s the occasion?'),
              const SizedBox(height: 12),
              _buildOccasionSelector(),
              const SizedBox(height: 24),

              // Question 2: Platform
              _buildSectionTitle('2. Which platform?'),
              const SizedBox(height: 12),
              _buildPlatformSelector(),
              const SizedBox(height: 24),

              // Question 3: Description
              _buildSectionTitle('3. Brief description'),
              const SizedBox(height: 12),
              _buildDescriptionField(),
              const SizedBox(height: 32),

              // Submit button
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primarygreen.withOpacity(0.1),
            AppColors.lightGreen.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primarygreen.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primarygreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI-Powered Content',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primarygreen,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Answer a few quick questions and let AI help you create the perfect post',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.primarygreen,
      ),
    );
  }

  Widget _buildOccasionSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGreen),
      ),
      child: Column(
        children: _occasions.map((occasion) {
          final isSelected = _selectedOccasion == occasion;
          return InkWell(
            onTap: () => setState(() => _selectedOccasion = occasion),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primarygreen.withOpacity(0.1) : Colors.transparent,
                border: Border(
                  bottom: BorderSide(
                    color: _occasions.last == occasion ? Colors.transparent : AppColors.border,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                    color: isSelected ? AppColors.primarygreen : Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    occasion,
                    style: TextStyle(
                      fontSize: 15,
                      color: isSelected ? AppColors.primarygreen : Colors.black87,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPlatformSelector() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _platforms.map((platform) {
        final isSelected = _selectedPlatform == platform;
        return GestureDetector(
          onTap: () => setState(() => _selectedPlatform = platform),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primarygreen : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isSelected ? AppColors.primarygreen : AppColors.lightGreen,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getPlatformIcon(platform),
                  size: 20,
                  color: isSelected ? Colors.white : AppColors.primarygreen,
                ),
                const SizedBox(width: 8),
                Text(
                  platform,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.primarygreen,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _getPlatformIcon(String platform) {
    switch (platform) {
      case 'Instagram':
        return Icons.camera_alt;
      case 'Facebook':
        return Icons.facebook;
      case 'LinkedIn':
        return Icons.business;
      case 'TikTok':
        return Icons.music_note;
      default:
        return Icons.public;
    }
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 5,
      decoration: InputDecoration(
        hintText: 'e.g., "Showcase our new sustainable furniture line made from reclaimed wood. Target audience: eco-conscious homeowners..."',
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.lightGreen),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.lightGreen),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primarygreen, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(16),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please provide a brief description';
        }
        if (value.trim().length < 10) {
          return 'Please provide more details (at least 10 characters)';
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primarygreen,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: _isLoading
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.auto_awesome, size: 20),
            SizedBox(width: 8),
            Text(
              'Start Creating with AI',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Prepare the initial context message for AI (hidden from user)
      final contextPrompt = '''
I'm working on a ${_selectedOccasion.toLowerCase()} post for ${_selectedPlatform}.

Project details: ${_descriptionController.text.trim()}

Please help me create engaging content that:
- Fits the ${_selectedPlatform} platform style and best practices
- Is appropriate for a ${_selectedOccasion.toLowerCase()}
- Resonates with my target audience
- Includes relevant hashtags and call-to-action

Let's start by discussing ideas and approach.
''';

      final aiService = AiChatService();

      // Send initial message to AI to set context
      final initialResponse = await aiService.sendMessage(contextPrompt);

      // Create initial chat history with context
      final initialMessages = [
        ChatMessage(
          id: '0',
          content: contextPrompt,
          isUser: true,
          timestamp: DateTime.now(),
        ),
        ChatMessage(
          id: '1',
          content: initialResponse,
          isUser: false,
          timestamp: DateTime.now(),
        ),
      ];

      setState(() => _isLoading = false);

      // Navigate to chat screen with pre-loaded context
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PostCreationChatScreen(
            occasion: _selectedOccasion,
            platform: _selectedPlatform,
            description: _descriptionController.text.trim(),
            initialMessages: initialMessages,
          ),
        ),
      );
    } catch (e) {
      setState(() => _isLoading = false);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}