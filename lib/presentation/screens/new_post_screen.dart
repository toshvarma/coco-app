import 'package:flutter/material.dart';
import 'package:coco_app/core/constants/colors.dart';
import 'package:coco_app/core/constants/text_styles.dart';
import 'post_questionnaire_screen.dart';

class NewPostScreen extends StatelessWidget {
  const NewPostScreen({super.key});


  @override
  Widget build(BuildContext context) {
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
  return const Scaffold(
  body: Center(
  child: CircularProgressIndicator(),
  ),
  );
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create New Post',
                style: AppTextStyles.heading1,
              ),
              const SizedBox(height: 8),
              const Text(
                'Start your post generation',
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: 40),
              Center(
                child: Text(
                  'Post generation coming soon...',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
