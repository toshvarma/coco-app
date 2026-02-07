import 'package:flutter/material.dart';
import 'post_questionnaire_screen.dart';

class NewPostScreen extends StatelessWidget {
  const NewPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Immediately navigate to questionnaire
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const PostQuestionnaireScreen(),
        ),
      );
    });

    // Show loading while navigating
    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Center(
        child: CircularProgressIndicator(
          color: colorScheme.primary,
        ),
      ),
    );
  }
}