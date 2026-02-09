import 'package:flutter/material.dart';
import '../../domain/models/chat_message_model.dart';
import '../../data/services/ai_chat_service.dart';
import 'post_ready_screen.dart';

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
            imagePath: 'assets/templates/instagram/instagram-template1.png',
          ),
          TemplateType(
            name: 'Reel Script',
            description: 'Short video script with hooks',
            icon: Icons.video_library,
            imagePath: 'assets/templates/instagram/instagram-template2.png',
          ),
          TemplateType(
            name: 'Story Series',
            description: 'Multiple story frames',
            icon: Icons.auto_stories,
            imagePath: 'assets/templates/instagram/instagram-template3.png',
          ),
        ];
      case 'LinkedIn':
        return [
          TemplateType(
            name: 'Professional Post',
            description: 'Thought leadership content',
            icon: Icons.work,
            imagePath: 'assets/templates/linkedin/linkedin-template1.png',
          ),
          TemplateType(
            name: 'Carousel Article',
            description: 'Multi-slide professional insights',
            icon: Icons.article,
            imagePath: 'assets/templates/linkedin/linkedin-template2.png',
          ),
        ];
      case 'Facebook':
        return [
          TemplateType(
            name: 'Engaging Post',
            description: 'Community-focused content',
            icon: Icons.photo,
            imagePath: 'assets/templates/facebook/facebook-template1.png',
          ),
          TemplateType(
            name: 'Video Post',
            description: 'Video content with description',
            icon: Icons.videocam,
            imagePath: 'assets/templates/facebook/facebook-template2.png',
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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        title: Text(
          'Choose Your Template',
          style: TextStyle(
            color: colorScheme.onPrimary,
          ),
        ),
        iconTheme: IconThemeData(
          color: colorScheme.onPrimary,
        ),
        actions: [
          if (!_isLoading && _generatedTemplates.isNotEmpty)
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
                    '2/2',
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
      body: _isLoading
          ? _buildLoadingState()
          : _error != null
          ? _buildErrorState()
          : _buildSwipeableTemplates(),
    );
  }

  Widget _buildLoadingState() {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'COCO is creating your templates...',
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This may take a few moments',
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: colorScheme.error.withOpacity(0.7)),
            const SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: colorScheme.onSurface),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _generateTemplates,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwipeableTemplates() {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
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

        Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () => _selectTemplate(_generatedTemplates[_currentPage]),
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
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colorScheme.primary, colorScheme.primary],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(template.type.icon, color: colorScheme.onPrimary, size: 20),
                const SizedBox(width: 8),
                Text(
                  template.type.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),


          Container(
            width: 280,
            decoration: BoxDecoration(
              color: colorScheme.surface,
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

                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  child: Image.asset(
                    template.type.imagePath,
                    width: 280,
                    height: 400,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {

                      return Container(
                        width: 280,
                        height: 400,
                        color: colorScheme.surfaceVariant,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_outlined,
                              size: 80,
                              color: colorScheme.onSurface.withOpacity(0.3),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Post Preview',
                              style: TextStyle(
                                fontSize: 16,
                                color: colorScheme.onSurface.withOpacity(0.6),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                Container(
                  width: 280,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (template.caption.isNotEmpty) ...[
                        Text(
                          template.caption,
                          style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.onSurface,
                            height: 1.4,
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                      ],

                      if (template.hashtags.isNotEmpty)
                        Text(
                          template.hashtags,
                          style: TextStyle(
                            fontSize: 13,
                            color: colorScheme.primary,
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
                        ? colorScheme.primary
                        : colorScheme.onSurface.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _selectTemplate(GeneratedTemplate template) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostReadyScreen(
          platform: widget.platform,
          templateName: template.type.name,
          caption: template.caption,
          hashtags: template.hashtags,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}


class TemplateType {
  final String name;
  final String description;
  final IconData icon;
  final String imagePath;

  TemplateType({
    required this.name,
    required this.description,
    required this.icon,
    required this.imagePath,
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