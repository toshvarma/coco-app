import 'package:flutter/material.dart';
import 'package:coco_app/core/constants/colors.dart';
import 'package:coco_app/core/constants/text_styles.dart';
import 'package:coco_app/core/widgets/custom_card.dart';
import 'package:coco_app/presentation/screens/analytics_screen.dart';
import 'package:coco_app/presentation/screens/new_post_screen.dart';
import 'package:coco_app/presentation/screens/calendar_screen.dart';
import 'package:coco_app/presentation/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  List<Widget> get _screens => [
    DashboardScreen(onNavigate: _navigateToIndex),
    const AnalyticsScreen(),
    const NewPostScreen(),
    const ProfileScreen(),
  ];

  void _navigateToIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _screens[_currentIndex],
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                index: 0,
              ),
              _buildNavItem(
                icon: Icons.bar_chart_rounded,
                label: 'Stats',
                index: 1,
              ),
              _buildNavItem(
                icon: Icons.add_circle_rounded,
                label: 'New Post',
                index: 2,
                isCenter: true,
              ),
              _buildNavItem(
                icon: Icons.person_rounded,
                label: 'Profile',
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    bool isCenter = false,
  }) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: isCenter ? 32 : 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dashboard Screen (Main Home Content)
class DashboardScreen extends StatelessWidget {
  final Function(int) onNavigate;

  const DashboardScreen({
    super.key,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dashboard',
                  style: AppTextStyles.heading1,
                ),
                const SizedBox(height: 4),
                Text(
                  'Ichbin Architekt',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Your Performance Card
            _buildPerformanceCard(),

            const SizedBox(height: 20),

            // Let's Review Card
            _buildReviewCard(),

            const SizedBox(height: 20),

            // Your Calendar Card
            _buildCalendarCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceCard() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your performance',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 4),
          Text(
            'past 7 days',
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: 80),
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: () => onNavigate(1),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.arrow_downward,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Let's Review",
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 12),
          Text(
            'You have been using COCO for 999 days now. Let\'s see your strengths and work on what could be better.',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: () => onNavigate(1),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.arrow_downward,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarCard(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Calendar',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 8),
          Text(
            '16th December, 2025',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 20),

          _buildScheduledItem('Instagram Reel', 'scheduled for 18:30'),
          const SizedBox(height: 12),
          _buildScheduledItem('LinkedIn Post', 'scheduled for 19:45'),
          const SizedBox(height: 12),
          _buildScheduledItem(
            '"Review Coco feedback on previous 90 days"',
            '18:00 - 18:30',
          ),

          const SizedBox(height: 24),

          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                print('Calendar button tapped!');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CalendarScreen(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.arrow_downward,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduledItem(String title, String time) {
    return Container(
      padding: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
      ),
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
            time,
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}