import 'package:flutter/material.dart';
import 'package:coco_app/core/constants/colors.dart';
import 'package:coco_app/core/constants/text_styles.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

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
              Text(
                'Analytics',
                style: AppTextStyles.heading1,
              ),
              const SizedBox(height: 8),
              Text(
                'Your performance insights',
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: 40),
              Center(
                child: Text(
                  'Analytics screen coming soon...',
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
}