import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
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
  final ImagePicker _picker = ImagePicker();

  String _selectedOccasion = 'Product Launch';
  String _selectedPlatform = 'Instagram';
  final TextEditingController _descriptionController = TextEditingController();
  List<XFile> _selectedImages = [];

  bool _isLoading = false;

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

  final List<String> _platforms = [
    'Instagram',
    'Facebook',
    'LinkedIn',
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: colorScheme.onPrimary),  // Explicitly set to white
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => false,
            );
          },
        ),
        title: const Text('Create New Post'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        iconTheme: IconThemeData(color: colorScheme.onPrimary),  // Also set iconTheme
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),

              _buildSectionTitle('1. What\'s the occasion?'),
              const SizedBox(height: 12),
              _buildOccasionSelector(),
              const SizedBox(height: 24),

              _buildSectionTitle('2. Which platform?'),
              const SizedBox(height: 12),
              _buildPlatformSelector(),
              const SizedBox(height: 24),

              _buildSectionTitle('3. Brief description'),
              const SizedBox(height: 12),
              _buildDescriptionField(),
              const SizedBox(height: 24),

              // NEW: Image upload section
              _buildSectionTitle('4. Add images (optional)'),
              const SizedBox(height: 12),
              _buildImageUploadSection(),
              const SizedBox(height: 32),

              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer.withOpacity(0.1),
            colorScheme.secondaryContainer.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.auto_awesome,
              color: colorScheme.onPrimary,
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
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Answer a few quick questions and let AI help you create the perfect post',
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurface.withOpacity(0.7),
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
    final colorScheme = Theme.of(context).colorScheme;

    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: colorScheme.primary,
      ),
    );
  }

  Widget _buildOccasionSelector() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
      ),
      child: Column(
        children: _occasions.map((occasion) {
          final isSelected = _selectedOccasion == occasion;
          return InkWell(
            onTap: () => setState(() => _selectedOccasion = occasion),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isSelected ? colorScheme.primary.withOpacity(0.1) : Colors.transparent,
                border: Border(
                  bottom: BorderSide(
                    color: _occasions.last == occasion ? Colors.transparent : colorScheme.outline.withOpacity(0.2),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                    color: isSelected ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.5),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    occasion,
                    style: TextStyle(
                      fontSize: 15,
                      color: isSelected ? colorScheme.primary : colorScheme.onSurface,
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
    final colorScheme = Theme.of(context).colorScheme;

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
              color: isSelected ? colorScheme.primary : colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isSelected ? colorScheme.primary : colorScheme.outline.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getPlatformIcon(platform),
                  size: 20,
                  color: isSelected ? colorScheme.onPrimary : colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  platform,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? colorScheme.onPrimary : colorScheme.primary,
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
      default:
        return Icons.public;
    }
  }

  Widget _buildDescriptionField() {
    final colorScheme = Theme.of(context).colorScheme;

    return TextFormField(
      controller: _descriptionController,
      maxLines: 5,
      decoration: InputDecoration(
        hintText: 'e.g., "Showcase our new sustainable furniture line made from reclaimed wood. Target audience: eco-conscious homeowners..."',
        hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.5), fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        filled: true,
        fillColor: colorScheme.surface,
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

  // NEW: Image upload section
  Widget _buildImageUploadSection() {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Upload buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _pickImages(ImageSource.gallery),
                icon: Icon(Icons.photo_library, color: colorScheme.primary),
                label: Text(
                  'From Gallery',
                  style: TextStyle(color: colorScheme.primary),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: colorScheme.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _pickImages(ImageSource.camera),
                icon: Icon(Icons.camera_alt, color: colorScheme.primary),
                label: Text(
                  'Take Photo',
                  style: TextStyle(color: colorScheme.primary),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: colorScheme.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),

        // Display selected images
        if (_selectedImages.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_selectedImages.length} image${_selectedImages.length > 1 ? 's' : ''} selected',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => setState(() => _selectedImages.clear()),
                      icon: const Icon(Icons.clear, size: 16),
                      label: const Text('Clear All'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedImages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(_selectedImages[index].path),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedImages.removeAt(index);
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // NEW: Pick images method
  Future<void> _pickImages(ImageSource source) async {
    try {
      if (source == ImageSource.gallery) {
        final List<XFile> images = await _picker.pickMultiImage();
        if (images.isNotEmpty) {
          setState(() {
            _selectedImages.addAll(images);
          });
        }
      } else {
        final XFile? image = await _picker.pickImage(source: source);
        if (image != null) {
          setState(() {
            _selectedImages.add(image);
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking images: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildSubmitButton() {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: _isLoading
            ? SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary),
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_awesome, size: 20),
            const SizedBox(width: 8),
            Text(
              _selectedImages.isNotEmpty
                  ? 'Start Creating with COCO'
                  : 'Start Creating with COCO',
              style: const TextStyle(
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
      String contextPrompt = '''
I'm working on a ${_selectedOccasion.toLowerCase()} post for ${_selectedPlatform}.

Project details: ${_descriptionController.text.trim()}
''';

      if (_selectedImages.isNotEmpty) {
        contextPrompt += '\n\nI have ${_selectedImages.length} image${_selectedImages.length > 1 ? 's' : ''} to include in this post.';
      }

      contextPrompt += '''

Please help me create engaging content that:
- Fits the ${_selectedPlatform} platform style and best practices
- Is appropriate for a ${_selectedOccasion.toLowerCase()}
- Resonates with my target audience
- Includes relevant hashtags and call-to-action

Let's start by discussing ideas and approach.
''';

      final aiService = AiChatService();
      final initialResponse = await aiService.sendMessage(contextPrompt);

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