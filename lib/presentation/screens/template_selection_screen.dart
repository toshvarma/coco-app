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
  bool _isLoading = true;
  String? _error;
  List<GeneratedTemplate> _generatedTemplates = [];
  int? _selectedIndex;

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
      // Get template types for this platform
      final templateTypes = _getTemplateTypesForPlatform(widget.platform);

      // Build the AI prompt to generate templates
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
4. Any format-specific elements (e.g., for carousel: slide titles, for video: script outline)

Format your response as follows for each template:

---TEMPLATE: [Template Name]---
CAPTION:
[Your caption here]

HASHTAGS:
[Your hashtags here]

CALL_TO_ACTION:
[Your CTA here]

FORMAT_SPECIFIC:
[Any additional format-specific content]
---END TEMPLATE---

Make each version unique and optimized for its specific format. Be creative and professional.
''';

      // Send to AI
      final response = await _aiService.sendMessage(
        prompt,
        chatHistory: widget.chatHistory.map((msg) => msg.toApiFormat()).toList(),
      );

      // Parse the AI response
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

    // Split by template markers
    final sections = response.split('---TEMPLATE:');

    for (var i = 1; i < sections.length; i++) {
      try {
        final section = sections[i];
        final endIndex = section.indexOf('---END TEMPLATE---');
        final content = endIndex != -1 ? section.substring(0, endIndex) : section;

        // Extract template name
        final nameMatch = RegExp(r'^([^\n]+)').firstMatch(content);
        final templateName = nameMatch?.group(1)?.trim() ?? 'Template ${i}';

        // Extract caption
        final captionMatch = RegExp(r'CAPTION:\s*\n(.*?)(?=\n\nHASHTAGS:|$)', dotAll: true).firstMatch(content);
        final caption = captionMatch?.group(1)?.trim() ?? '';

        // Extract hashtags
        final hashtagsMatch = RegExp(r'HASHTAGS:\s*\n(.*?)(?=\n\nCALL_TO_ACTION:|$)', dotAll: true).firstMatch(content);
        final hashtags = hashtagsMatch?.group(1)?.trim() ?? '';

        // Extract CTA
        final ctaMatch = RegExp(r'CALL_TO_ACTION:\s*\n(.*?)(?=\n\nFORMAT_SPECIFIC:|$)', dotAll: true).firstMatch(content);
        final cta = ctaMatch?.group(1)?.trim() ?? '';

        // Extract format-specific
        final formatMatch = RegExp(r'FORMAT_SPECIFIC:\s*\n(.*?)$', dotAll: true).firstMatch(content);
        final formatSpecific = formatMatch?.group(1)?.trim() ?? '';

        // Find matching template type
        final templateType = types.firstWhere(
              (t) => templateName.toLowerCase().contains(t.name.toLowerCase().split(' ').first),
          orElse: () => types[i - 1 < types.length ? i - 1 : 0],
        );

        templates.add(GeneratedTemplate(
          type: templateType,
          caption: caption,
          hashtags: hashtags,
          callToAction: cta,
          formatSpecific: formatSpecific,
        ));
      } catch (e) {
        print('Error parsing template $i: $e');
      }
    }

    // If parsing failed, create fallback templates
    if (templates.isEmpty) {
      for (var type in types) {
        templates.add(GeneratedTemplate(
          type: type,
          caption: response,
          hashtags: '',
          callToAction: '',
          formatSpecific: '',
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
        title: const Text('Choose Your Template'),
        backgroundColor: AppColors.primarygreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _error != null
          ? _buildErrorState()
          : _buildTemplateList(),
      bottomNavigationBar: _selectedIndex != null && !_isLoading
          ? _buildContinueButton()
          : null,
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primarygreen),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'AI is creating your templates...',
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

  Widget _buildTemplateList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _generatedTemplates.length,
      itemBuilder: (context, index) {
        final template = _generatedTemplates[index];
        final isSelected = _selectedIndex == index;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColors.primarygreen : AppColors.border,
                width: isSelected ? 3 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? AppColors.primarygreen.withOpacity(0.3)
                      : Colors.black.withOpacity(0.05),
                  blurRadius: isSelected ? 12 : 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isSelected
                          ? [AppColors.primarygreen, AppColors.primarygreen]
                          : [AppColors.lightGreen.withOpacity(0.3), AppColors.background],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        template.type.icon,
                        color: isSelected ? Colors.white : AppColors.primarygreen,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          template.type.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : AppColors.primarygreen,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle, color: Colors.white, size: 24),
                    ],
                  ),
                ),

                // Content preview
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Caption
                      if (template.caption.isNotEmpty) ...[
                        Row(
                          children: [
                            Icon(Icons.text_fields, size: 16, color: AppColors.primarygreen),
                            const SizedBox(width: 8),
                            Text(
                              'Caption',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primarygreen,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          template.caption,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.5,
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Hashtags
                      if (template.hashtags.isNotEmpty) ...[
                        Row(
                          children: [
                            Icon(Icons.tag, size: 16, color: AppColors.primarygreen),
                            const SizedBox(width: 8),
                            Text(
                              'Hashtags',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primarygreen,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          template.hashtags,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue[700],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 16),
                      ],

                      // CTA
                      if (template.callToAction.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primarygreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.primarygreen.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.touch_app, size: 16, color: AppColors.primarygreen),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  template.callToAction,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primarygreen,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      // Format-specific
                      if (template.formatSpecific.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        ExpansionTile(
                          title: Text(
                            'Additional Details',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primarygreen,
                            ),
                          ),
                          tilePadding: EdgeInsets.zero,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                template.formatSpecific,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ],

                      // Copy button
                      const SizedBox(height: 12),
                      TextButton.icon(
                        onPressed: () => _copyTemplate(template),
                        icon: const Icon(Icons.copy, size: 16),
                        label: const Text('Copy All'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primarygreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContinueButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: _handleUseTemplate,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primarygreen,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Use This Template',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void _copyTemplate(GeneratedTemplate template) {
    final fullText = '''
${template.caption}

${template.hashtags}

${template.callToAction}

${template.formatSpecific}
''';

    Clipboard.setData(ClipboardData(text: fullText.trim()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Template copied to clipboard!'),
        backgroundColor: AppColors.primarygreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleUseTemplate() {
    final selected = _generatedTemplates[_selectedIndex!];

    _copyTemplate(selected);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.primarygreen),
            const SizedBox(width: 12),
            const Expanded(child: Text('Template Copied!')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your ${selected.type.name} is ready to use!',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: const [
                  Icon(Icons.check, size: 16, color: Colors.green),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Copied to clipboard',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'What would you like to do next?',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        actions: [
          // Go back to chat
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to chat
            },
            icon: const Icon(Icons.chat, size: 18),
            label: const Text('Edit with AI'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primarygreen,
            ),
          ),
          // Stay here
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context); // Only close dialog
            },
            icon: const Icon(Icons.done, size: 18),
            label: const Text('Select Another'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primarygreen,
              backgroundColor: AppColors.primarygreen.withOpacity(0.1),
            ),
          ),
        ],
        actionsAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
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
  final String formatSpecific;

  GeneratedTemplate({
    required this.type,
    required this.caption,
    required this.hashtags,
    required this.callToAction,
    required this.formatSpecific,
  });
}