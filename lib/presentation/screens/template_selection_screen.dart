import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/colors.dart';
import '../../domain/models/chat_message_model.dart';
import '../../data/services/ai_chat_service.dart';

class TemplateSelectionScreen extends StatefulWidget {
  final String platform;
  final String occasion;
  final List<ChatMessage> chatHistory;

  const TemplateSelectionScreen({
    super.key,
    required this.platform,
    required this.occasion,
    required this.chatHistory,
  });

  @override
  State<TemplateSelectionScreen> createState() => _TemplateSelectionScreenState();
}

class _TemplateSelectionScreenState extends State<TemplateSelectionScreen> {
  final AiChatService _aiService = AiChatService();
  final PageController _pageController = PageController();

  bool _isLoading = true;
  String? _error;
  List<GeneratedTemplate> _generatedTemplates = [];
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _generateTemplates();
  }

  Future<void> _generateTemplates() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final templateTypes = _getTemplateTypesForPlatform(widget.platform);

      final conversationSummary = widget.chatHistory
          .where((msg) => !msg.isUser)
          .map((msg) => msg.content)
          .join('\n\n');

      final prompt = '''
Based on our conversation about creating a ${widget.occasion} for ${widget.platform}, please generate ${templateTypes.length} different post variations, one for each of these formats:

${templateTypes.map((t) => '- ${t.name}: ${t.description}').join('\n')}

For EACH format, provide:
1. A compelling caption/post text (appropriate length for the format)
2. 5-8 relevant hashtags
3. A call-to-action

Format your response as follows for each template:

---TEMPLATE: [Template Name]---
CAPTION:
[Your caption here]

HASHTAGS:
[Your hashtags here]

CALL_TO_ACTION:
[Your CTA here]
---END TEMPLATE---

Make each version unique and optimized for its specific format. Be creative and professional.
''';

      final response = await _aiService.sendMessage(
        prompt,
        chatHistory: widget.chatHistory.map((msg) => msg.toApiFormat()).toList(),
      );

      final templates = _parseAIResponse(response, templateTypes);

      setState(() {
        _generatedTemplates = templates;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to generate templates. Please try again.';
        _isLoading = false;
      });
    }
  }

  List<TemplateType> _getTemplateTypesForPlatform(String platform) {
    switch (platform) {
      case 'Instagram':
        return [
          TemplateType(
            name: 'Carousel Post',
            description: 'Multiple images with engaging captions',
            icon: Icons.view_carousel,
          ),
          TemplateType(
            name: 'Reel Script',
            description: 'Short video script with hooks',
            icon: Icons.video_library,
          ),
          TemplateType(
            name: 'Story Series',
            description: 'Multiple story frames',
            icon: Icons.auto_stories,
          ),
        ];
      case 'LinkedIn':
        return [
          TemplateType(
            name: 'Professional Post',
            description: 'Thought leadership content',
            icon: Icons.work,
          ),
          TemplateType(
            name: 'Carousel Article',
            description: 'Multi-slide professional insights',
            icon: Icons.article,
          ),
        ];
      case 'Facebook':
        return [
          TemplateType(
            name: 'Engaging Post',
            description: 'Community-focused content',
            icon: Icons.photo,
          ),
          TemplateType(
            name: 'Video Post',
            description: 'Video content with description',
            icon: Icons.videocam,
          ),
        ];
      case 'TikTok':
        return [
          TemplateType(
            name: 'Trending Video',
            description: 'Short-form video script',
            icon: Icons.music_note,
          ),
          TemplateType(
            name: 'Tutorial Style',
            description: 'Step-by-step guide',
            icon: Icons.school,
          ),
        ];
      default:
        return [];
    }
  }

  List<GeneratedTemplate> _parseAIResponse(String response, List<TemplateType> types) {
    final templates = <GeneratedTemplate>[];

    final sections = response.split('---TEMPLATE:');

    for (var i = 1; i < sections.length; i++) {
      try {
        final section = sections[i];
        final endIndex = section.indexOf('---END TEMPLATE---');
        final content = endIndex != -1 ? section.substring(0, endIndex) : section;

        final nameMatch = RegExp(r'^([^\n]+)').firstMatch(content);
        final templateName = nameMatch?.group(1)?.trim() ?? 'Template $i';

        final captionMatch = RegExp(r'CAPTION:\s*\n(.*?)(?=\n\nHASHTAGS:|$)', dotAll: true).firstMatch(content);
        final caption = captionMatch?.group(1)?.trim() ?? '';

        final hashtagsMatch = RegExp(r'HASHTAGS:\s*\n(.*?)(?=\n\nCALL_TO_ACTION:|$)', dotAll: true).firstMatch(content);
        final hashtags = hashtagsMatch?.group(1)?.trim() ?? '';

        final ctaMatch = RegExp(r'CALL_TO_ACTION:\s*\n(.*?)$', dotAll: true).firstMatch(content);
        final cta = ctaMatch?.group(1)?.trim() ?? '';

        final templateType = types.firstWhere(
              (t) => templateName.toLowerCase().contains(t.name.toLowerCase().split(' ').first),
          orElse: () => types[i - 1 < types.length ? i - 1 : 0],
        );

        templates.add(GeneratedTemplate(
          type: templateType,
          caption: caption,
          hashtags: hashtags,
          callToAction: cta,
        ));
      } catch (e) {
        print('Error parsing template $i: $e');
      }
    }

    if (templates.isEmpty) {
      for (var type in types) {
        templates.add(GeneratedTemplate(
          type: type,
          caption: response,
          hashtags: '',
          callToAction: '',
        ));
      }
    }

    return templates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primarygreen, // Green background
          foregroundColor: Colors.white, // White text
          elevation: 0,
          title: const Text(
            'Choose Your Template',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white, // White back arrow
          ),
          actions: [
            if (!_isLoading && _generatedTemplates.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '2/2',
                      style: TextStyle(
                        color: AppColors.primarygreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      body: _isLoading
          ? _buildLoadingState()
          : _error != null
          ? _buildErrorState()
          : _buildSwipeableTemplates(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primarygreen),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'COCO is creating your templates...',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.primarygreen,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This may take a few moments',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _generateTemplates,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primarygreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwipeableTemplates() {
    return Column(
      children: [
        // Swipeable templates
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: _generatedTemplates.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return _buildTemplatePage(_generatedTemplates[index]);
            },
          ),
        ),

        // Fixed button at bottom (doesn't swipe)
        Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () => _selectTemplate(_generatedTemplates[_currentPage]),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primarygreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: const Text(
                'Select Template',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildTemplatePage(GeneratedTemplate template) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Template name header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primarygreen, AppColors.primarygreen],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(template.type.icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  template.type.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Phone mockup with portrait image placeholder
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                // Portrait image placeholder
                Container(
                  width: 280,
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_outlined,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Post Preview',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Caption and hashtags
                Container(
                  width: 280,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Caption
                      if (template.caption.isNotEmpty) ...[
                        Text(
                          template.caption,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            height: 1.4,
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Hashtags
                      if (template.hashtags.isNotEmpty)
                        Text(
                          template.hashtags,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue[700],
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Swipe indicators (dots) - underneath preview
          if (_generatedTemplates.length > 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _generatedTemplates.length,
                    (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppColors.primarygreen
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

          // Remove Spacer and button from here - they're now fixed at bottom
        ],
      ),
    );
  }

  Widget _buildContentSection(String title, IconData icon, String content, {Color? textColor}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primarygreen),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primarygreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 15,
              color: textColor ?? Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  void _selectTemplate(GeneratedTemplate template) {
    // Copy to clipboard
    final fullText = '''
${template.caption}

${template.hashtags}
''';

    Clipboard.setData(ClipboardData(text: fullText.trim()));

    // Show confirmation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.primarygreen, size: 28),
            SizedBox(width: 12),
            Expanded(child: Text('Template Selected!')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primarygreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.copy_all, color: AppColors.primarygreen, size: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Content copied to clipboard',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primarygreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Your ${template.type.name.toLowerCase()} is ready to post on ${widget.platform}!',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'View Another',
              style: TextStyle(color: AppColors.primarygreen),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to chat
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primarygreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

// Models
class TemplateType {
  final String name;
  final String description;
  final IconData icon;

  TemplateType({
    required this.name,
    required this.description,
    required this.icon,
  });
}

class GeneratedTemplate {
  final TemplateType type;
  final String caption;
  final String hashtags;
  final String callToAction;

  GeneratedTemplate({
    required this.type,
    required this.caption,
    required this.hashtags,
    required this.callToAction,
  });
}