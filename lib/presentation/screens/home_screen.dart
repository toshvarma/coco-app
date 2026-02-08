import 'package:flutter/material.dart';
import 'package:coco_app/core/constants/text_styles.dart';
import 'package:coco_app/core/widgets/custom_card.dart';
import 'package:coco_app/presentation/screens/analytics_screen.dart';
import 'package:coco_app/presentation/screens/new_post_screen.dart';
import 'package:coco_app/presentation/screens/calendar_screen.dart';
import 'package:coco_app/presentation/screens/profile_screen.dart';
import 'package:coco_app/presentation/screens/chat_screen.dart';
import 'package:coco_app/data/services/auth_service.dart';
import 'package:coco_app/presentation/screens/review_screen.dart';
import 'package:coco_app/data/services/review_service.dart';

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
    const CalendarScreenWithNavbar(),
    const ProfileScreen(),
  ];

  void _navigateToIndex(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _screens[_currentIndex],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatScreen()),
          );
        },
        backgroundColor: cs.primary,
        icon: Icon(Icons.chat_bubble_outline, color: cs.onPrimary),
        label: Text('AI Chat', style: TextStyle(color: cs.onPrimary)),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: cs.surface,
        selectedItemColor: cs.primary,
        unselectedItemColor: cs.onSurface.withOpacity(0.6),
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_rounded), label: 'Stats'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_rounded), label: 'New'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_rounded), label: 'Calendar'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}

// ------------------------------------------------------
// DASHBOARD SCREEN — WITH DYNAMIC USER NAME
// ------------------------------------------------------

class DashboardScreen extends StatefulWidget {
  final Function(int) onNavigate;

  const DashboardScreen({super.key, required this.onNavigate});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _authService = AuthService();
  String _userName = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final user = await _authService.getCurrentUser();
    if (user != null && mounted) {
      setState(() {
        _userName = user['name'] ?? 'User';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _header(context),
            const SizedBox(height: 16),
            _performanceCard(context),
            const SizedBox(height: 16),
            _reviewCard(context),
            const SizedBox(height: 16),
            _calendarCard(context),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _iconTile(context, Icons.person_outline),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dashboard',
                    style: AppTextStyles.heading2
                        .copyWith(color: cs.onPrimary)),
                Text(_userName,
                    style: AppTextStyles.bodySmall
                        .copyWith(color: cs.onPrimary.withOpacity(0.9))),
              ],
            ),
          ),
          _iconTile(context, Icons.notifications_outlined),
        ],
      ),
    );
  }

  Widget _iconTile(BuildContext context, IconData icon) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: cs.onPrimary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: cs.onPrimary),
    );
  }

  Widget _performanceCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _iconBadge(context, Icons.trending_up),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your performance',
                        style: AppTextStyles.bodySmall
                            .copyWith(fontWeight: FontWeight.w600)),
                    Text('past 7 days',
                        style: AppTextStyles.caption),
                  ],
                ),
              ),
              _arrow(context, () => widget.onNavigate(1)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              _StatItem(label: 'Posts', value: '12', icon: Icons.article),
              _DividerLine(),
              _StatItem(label: 'Reach', value: '3.5k', icon: Icons.visibility),
              _DividerLine(),
              _StatItem(
                  label: 'Engagement', value: '24%', icon: Icons.favorite),
            ],
          ),
        ],
      ),
    );
  }

  Widget _reviewCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return CustomCard(
      backgroundColor: cs.primaryContainer.withOpacity(0.15),
      child: Row(
        children: [
          _iconBadge(context, Icons.star_outline),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Let's Review",
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    )),
                const SizedBox(height: 4),
                Text(
                  "You have been using COCO for 60 days now. Let's see your strengths and work on what could be better.",
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          _arrow(context, () {
            // Get the review data for the current user
            final reviewData = ReviewService().getReviewForUser(_userName == 'Lena Hoffman' ? 'lena' : 'mike');

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ReviewScreen(reviewData: reviewData),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _calendarCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Your Calendar',
                    style: AppTextStyles.heading3),
              ),
              _arrow(context, () => widget.onNavigate(3)),
            ],
          ),
          const SizedBox(height: 4),
          Text('28th January, 2026', style: AppTextStyles.caption),
          const SizedBox(height: 12),

          _calendarItem('Instagram Reel', 'scheduled for 14:30'),
          _calendarItem('LinkedIn Post', 'scheduled for 18:45'),

          const Divider(height: 24),

          Text('Next Upcoming',
              style: AppTextStyles.bodySmall
                  .copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),

          _calendarItem(
            'Instagram Post - Eco-friendly materials',
            'Jan 31 at 10:00',
          ),
        ],
      ),
    );
  }

  Widget _calendarItem(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTextStyles.bodySmall
                        .copyWith(fontWeight: FontWeight.w600)),
                Text(subtitle, style: AppTextStyles.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconBadge(BuildContext context, IconData icon) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: cs.primary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: cs.primary),
    );
  }

  Widget _arrow(BuildContext context, VoidCallback onTap) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: cs.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.arrow_forward, color: cs.primary, size: 18),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 20, color: cs.primary),
          const SizedBox(height: 4),
          Text(value,
              style: AppTextStyles.bodySmall
                  .copyWith(fontWeight: FontWeight.w600)),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
    );
  }
}