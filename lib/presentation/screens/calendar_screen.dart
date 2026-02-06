import 'package:flutter/material.dart';
import 'package:coco_app/core/constants/colors.dart';
import 'package:coco_app/core/constants/text_styles.dart';
import 'package:coco_app/core/widgets/custom_card.dart';

// Calendar screen WITH navbar (used in bottom nav)
class CalendarScreenWithNavbar extends StatelessWidget {
  const CalendarScreenWithNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Calendar',
              style: AppTextStyles.heading1,
            ),
            const SizedBox(height: 4),
            Text(
              'View and manage your scheduled posts',
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: 24),

            // Calendar Card
            _buildCalendarCard(),

            const SizedBox(height: 24),

            // Scheduled Posts Header
            Text(
              'Scheduled Posts',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 12),

            // Scheduled Posts List
            _buildScheduledPostItem(
              'Instagram Reel',
              'December 16, 2025',
              '18:30',
              Icons.camera_alt,
              AppColors.primary,
            ),
            const SizedBox(height: 8),

            _buildScheduledPostItem(
              'LinkedIn Post',
              'December 16, 2025',
              '19:45',
              Icons.article,
              AppColors.primaryDark,
            ),
            const SizedBox(height: 8),

            _buildScheduledPostItem(
              'Review Coco feedback',
              'December 16, 2025',
              '18:00 - 18:30',
              Icons.task_alt,
              AppColors.success,
            ),
          ],
        ),
      ),
    );
  }

// ... rest of the widget methods from before
}

// Calendar screen WITHOUT navbar (for push navigation - if needed)
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
      body: const CalendarScreenWithNavbar(),
    );
  }
}

// Shared widget methods
Widget _buildCalendarCard() {
  return CustomCard(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        // Month navigation
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, color: AppColors.textPrimary),
              onPressed: () {},
            ),
            Text(
              'December 2025',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, color: AppColors.textPrimary),
              onPressed: () {},
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Weekday headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
              .map((day) => SizedBox(
            width: 40,
            child: Center(
              child: Text(
                day,
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ))
              .toList(),
        ),

        const SizedBox(height: 12),

        // Calendar grid
        Column(
          children: [
            _buildWeekRow([1, 2, 3, 4, 5, 6, 7], [16]),
            _buildWeekRow([8, 9, 10, 11, 12, 13, 14], [16]),
            _buildWeekRow([15, 16, 17, 18, 19, 20, 21], [16]),
            _buildWeekRow([22, 23, 24, 25, 26, 27, 28], [16]),
            _buildWeekRow([29, 30, 31, null, null, null, null], [16]),
          ],
        ),
      ],
    ),
  );
}

Widget _buildWeekRow(List<int?> days, List<int> highlightedDays) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days.map((day) {
        if (day == null) {
          return const SizedBox(width: 40, height: 40);
        }

        final isHighlighted = highlightedDays.contains(day);
        final isToday = day == 16;

        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isToday
                ? AppColors.primary
                : isHighlighted
                ? AppColors.primary.withOpacity(0.1)
                : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  day.toString(),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isToday
                        ? AppColors.textWhite
                        : isHighlighted
                        ? AppColors.primary
                        : AppColors.textPrimary,
                    fontWeight: isToday || isHighlighted
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
                if (isHighlighted && !isToday)
                  Positioned(
                    bottom: 4,
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
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

Widget _buildScheduledPostItem(
    String title,
    String date,
    String time,
    IconData icon,
    Color iconColor,
    ) {
  return CustomCard(
    padding: const EdgeInsets.all(12),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),

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
              const SizedBox(height: 2),
              Text(
                '$date\n$time',
                style: AppTextStyles.caption.copyWith(
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),

        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: AppColors.textSecondary,
            size: 20,
          ),
          onPressed: () {},
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    ),
  );
}