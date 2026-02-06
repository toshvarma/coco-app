import 'package:flutter/material.dart';
import 'package:coco_app/core/constants/colors.dart';
import 'package:coco_app/core/constants/text_styles.dart';
import 'package:coco_app/core/widgets/custom_card.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Calendar',
          style: AppTextStyles.heading3,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'December 2025',
                style: AppTextStyles.heading2,
              ),
              const SizedBox(height: 8),
              Text(
                'View and manage your scheduled posts',
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: 32),

              // Calendar grid placeholder
              CustomCard(
                child: Column(
                  children: [
                    // Month header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: () {},
                        ),
                        Text(
                          'December 2025',
                          style: AppTextStyles.heading3,
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Weekday headers
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                          .map((day) => Text(
                        day,
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ))
                          .toList(),
                    ),
                    const SizedBox(height: 16),

                    // Simple calendar grid (you can enhance this later)
                    Text(
                      'Calendar grid coming soon...',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Scheduled posts section
              Text(
                'Scheduled Posts',
                style: AppTextStyles.heading3,
              ),
              const SizedBox(height: 16),

              _buildScheduledPostCard(
                'Instagram Reel',
                'December 16, 2025',
                '18:30',
                Icons.camera_alt,
              ),
              const SizedBox(height: 12),

              _buildScheduledPostCard(
                'LinkedIn Post',
                'December 16, 2025',
                '19:45',
                Icons.article,
              ),
              const SizedBox(height: 12),

              _buildScheduledPostCard(
                'Review Coco feedback',
                'December 16, 2025',
                '18:00 - 18:30',
                Icons.task_alt,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduledPostCard(
      String title,
      String date,
      String time,
      IconData icon,
      ) {
    return CustomCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: AppTextStyles.caption,
                ),
                Text(
                  time,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.more_vert,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}