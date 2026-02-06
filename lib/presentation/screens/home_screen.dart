import 'package:flutter/material.dart';
import 'package:coco_app/core/constants/colors.dart';
import 'package:coco_app/core/constants/text_styles.dart';
import 'package:coco_app/core/widgets/custom_button.dart';
import 'package:coco_app/core/widgets/custom_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Dashboard', style: AppTextStyles.heading1),
              const SizedBox(height: 8),
              const Text(
                'Manage your social media presence',
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: 32),

              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Your Performance', style: AppTextStyles.heading3),
                    const SizedBox(height: 4),
                    const Text('Past 7 days', style: AppTextStyles.caption),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('12', 'Posts'),
                        _buildStatItem('3.5k', 'Reach'),
                        _buildStatItem('24%', 'Engagement'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              const Text('Quick Actions', style: AppTextStyles.heading2),
              const SizedBox(height: 16),

              CustomButton(
                text: 'Create New Post',
                onPressed: () {},
                type: ButtonType.gradient,
                icon: Icons.add_circle_outline,
                isFullWidth: true,
              ),

              const SizedBox(height: 12),

              CustomButton(
                text: 'View Analytics',
                onPressed: () {},
                type: ButtonType.secondary,
                icon: Icons.analytics_outlined,
                isFullWidth: true,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.chat_bubble_outline),
        label: const Text('AI Help'),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.heading2.copyWith(color: AppColors.primary)),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}