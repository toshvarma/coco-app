import 'package:flutter/material.dart';

class PostReadyScreen extends StatelessWidget {
  final String platform;
  final String templateName;
  final String caption;
  final String hashtags;

  const PostReadyScreen({
    super.key,
    required this.platform,
    required this.templateName,
    required this.caption,
    required this.hashtags,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    size: 60,
                    color: colorScheme.onPrimary,
                  ),
                ),

                const SizedBox(height: 32),

                Text(
                  'Your post is ready\nand waiting',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimary,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Post confirmed!'),
                          backgroundColor: colorScheme.primary,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.secondaryContainer,
                      foregroundColor: colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Post Now',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Schedule Post'),
                        content: const Text('Feature coming soon!'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text(
                    'or schedule for later',
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                Text(
                  'Want to change something?',
                  style: TextStyle(color: colorScheme.onPrimary.withOpacity(0.7)),
                ),

                const SizedBox(height: 8),

                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Go Back',
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}