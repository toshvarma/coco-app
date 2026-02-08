import 'package:flutter/material.dart';
import 'package:coco_app/core/constants/text_styles.dart';
import 'package:coco_app/core/widgets/custom_card.dart';
import 'package:coco_app/domain/models/scheduled_post_model.dart';
import 'package:coco_app/data/services/schedule_service.dart';
import 'package:coco_app/core/widgets/add_post_dialog.dart';

class CalendarScreenWithNavbar extends StatefulWidget {
  const CalendarScreenWithNavbar({super.key});

  @override
  State<CalendarScreenWithNavbar> createState() => _CalendarScreenWithNavbarState();
}

class _CalendarScreenWithNavbarState extends State<CalendarScreenWithNavbar> {
  final ScheduleService _scheduleService = ScheduleService(); // Changed from PostStorageService
  int? selectedDay;
  Map<int, List<ScheduledPost>> scheduledPosts = {};
  bool isLoading = true;

  int currentYear = 2026;
  int currentMonth = 2; // February

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() => isLoading = true);

    // Fetch all posts from backend
    final allPosts = await _scheduleService.getAllScheduledPosts();

    // Group posts by day for current month
    final Map<int, List<ScheduledPost>> groupedPosts = {};

    for (var post in allPosts) {
      // Only include posts from current month/year
      if (post.date.year == currentYear && post.date.month == currentMonth) {
        final day = post.date.day;
        if (!groupedPosts.containsKey(day)) {
          groupedPosts[day] = [];
        }
        groupedPosts[day]!.add(post);
      }
    }

    setState(() {
      scheduledPosts = groupedPosts;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: colorScheme.primary,
        ),
      );
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calendar',
              style: AppTextStyles.heading1,
            ),
            const SizedBox(height: 4),
            Text(
              '${_getMonthName(currentMonth)} $currentYear • Today: ${DateTime.now().day} ${_getMonthName(DateTime.now().month)}',
              style: AppTextStyles.bodySmall.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),

            _buildPlatformLegend(),
            const SizedBox(height: 16),

            _buildCalendarCard(),

            const SizedBox(height: 24),

            if (selectedDay != null)
              _buildSelectedDayDetails()
            else
              _buildAllScheduledPosts(),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month];
  }

  Widget _buildPlatformLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildLegendItem('Instagram', _getPlatformColor('Instagram')),
        _buildLegendItem('Facebook', _getPlatformColor('Facebook')),
        _buildLegendItem('LinkedIn', _getPlatformColor('LinkedIn')),
      ],
    );
  }

  Widget _buildLegendItem(String platform, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(platform, style: AppTextStyles.caption),
      ],
    );
  }

  Color _getPlatformColor(String platform) {
    switch (platform.toLowerCase()) {
      case 'instagram':
        return const Color(0xFFE4405F);
      case 'facebook':
        return const Color(0xFF1877F2);
      case 'linkedin':
        return const Color(0xFF0A66C2);
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  Widget _buildCalendarCard() {
    final colorScheme = Theme.of(context).colorScheme;
    final daysInMonth = DateTime(currentYear, currentMonth + 1, 0).day;
    final firstWeekday = DateTime(currentYear, currentMonth, 1).weekday;

    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left, color: colorScheme.onSurface),
                onPressed: () {
                  setState(() {
                    if (currentMonth == 1) {
                      currentMonth = 12;
                      currentYear--;
                    } else {
                      currentMonth--;
                    }
                  });
                  _loadPosts();
                },
              ),
              Text(
                '${_getMonthName(currentMonth)} $currentYear',
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right, color: colorScheme.onSurface),
                onPressed: () {
                  setState(() {
                    if (currentMonth == 12) {
                      currentMonth = 1;
                      currentYear++;
                    } else {
                      currentMonth++;
                    }
                  });
                  _loadPosts();
                },
              ),
            ],
          ),

          const SizedBox(height: 12),

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
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ),
            ))
                .toList(),
          ),

          const SizedBox(height: 12),

          _buildCalendarGrid(daysInMonth, firstWeekday),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(int daysInMonth, int firstWeekday) {
    List<Widget> weeks = [];
    List<int?> currentWeek = [];

    // Add empty cells for days before the first day of month
    for (int i = 1; i < firstWeekday; i++) {
      currentWeek.add(null);
    }

    // Add all days of the month
    for (int day = 1; day <= daysInMonth; day++) {
      currentWeek.add(day);

      if (currentWeek.length == 7) {
        weeks.add(_buildWeekRow(currentWeek));
        currentWeek = [];
      }
    }

    // Fill last week with empty cells if needed
    while (currentWeek.length < 7 && currentWeek.isNotEmpty) {
      currentWeek.add(null);
    }
    if (currentWeek.isNotEmpty) {
      weeks.add(_buildWeekRow(currentWeek));
    }

    return Column(children: weeks);
  }

  Widget _buildWeekRow(List<int?> days) {
    final colorScheme = Theme.of(context).colorScheme;
    final today = DateTime.now();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: days.map((day) {
          if (day == null) {
            return const SizedBox(width: 40, height: 40);
          }

          final hasPosts = scheduledPosts.containsKey(day);
          final posts = scheduledPosts[day] ?? [];
          final isToday = day == today.day &&
              currentMonth == today.month &&
              currentYear == today.year;
          final isSelected = day == selectedDay;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDay = day;
              });
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primary
                    : isToday
                    ? colorScheme.primary.withOpacity(0.2)
                    : Colors.transparent,
                shape: BoxShape.circle,
                border: isToday && !isSelected
                    ? Border.all(color: colorScheme.primary, width: 2)
                    : null,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    day.toString(),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface,
                      fontWeight: isToday || hasPosts
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  if (hasPosts && !isSelected)
                    Positioned(
                      bottom: 6,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: posts.take(3).map((post) {
                          return Container(
                            width: 4,
                            height: 4,
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            decoration: BoxDecoration(
                              color: _getPlatformColor(post.platform),
                              shape: BoxShape.circle,
                            ),
                          );
                        }).toList(),
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

  Widget _buildSelectedDayDetails() {
    final colorScheme = Theme.of(context).colorScheme;
    final posts = scheduledPosts[selectedDay] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_getMonthName(currentMonth)} $selectedDay, $currentYear',
              style: AppTextStyles.heading3.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  selectedDay = null;
                });
              },
              child: Text(
                'View All',
                style: AppTextStyles.bodySmall.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (posts.isEmpty)
          CustomCard(
            child: Column(
              children: [
                Icon(
                  Icons.event_available,
                  color: colorScheme.onSurface.withOpacity(0.5),
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  'No posts scheduled',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          )
        else
          ...posts.map((post) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildPostCard(post, selectedDay!),
          )),
      ],
    );
  }

  Widget _buildAllScheduledPosts() {
    final colorScheme = Theme.of(context).colorScheme;
    final allDays = scheduledPosts.keys.toList()..sort();

    if (allDays.isEmpty) {
      return CustomCard(
        child: Column(
          children: [
            Icon(
              Icons.calendar_today,
              color: colorScheme.onSurface.withOpacity(0.5),
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              'No scheduled posts this month',
              style: AppTextStyles.bodySmall.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'All Scheduled Posts',
          style: AppTextStyles.heading3.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),

        ...allDays.map((day) {
          final posts = scheduledPosts[day]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: Text(
                  '${_getMonthName(currentMonth)} $day, $currentYear',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ),
              ...posts.map((post) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildPostCard(post, day),
              )),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildPostCard(ScheduledPost post, int day) {
    final colorScheme = Theme.of(context).colorScheme;
    final platformColor = _getPlatformColor(post.platform);

    return CustomCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: platformColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: platformColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      post.platform,
                      style: AppTextStyles.caption.copyWith(
                        color: platformColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (post.isDraft) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Draft',
                    style: AppTextStyles.caption.copyWith(
                      color: const Color(0xFFF59E0B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: colorScheme.onSurface.withOpacity(0.7),
                  size: 20,
                ),
                onSelected: (value) async {
                  if (value == 'delete') {
                    await _deletePost(post);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            post.topic,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          if (post.time != null) ...[
            const SizedBox(height: 4),
            Text(
              'Time: ${post.time}',
              style: AppTextStyles.caption.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ],
          if (post.note != null && post.note!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.background,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.note_outlined,
                    size: 14,
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      post.note!,
                      style: AppTextStyles.caption.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.8),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _deletePost(ScheduledPost post) async {
    final colorScheme = Theme.of(context).colorScheme;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this scheduled post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await _scheduleService.deletePost(post.id);
      if (success) {
        await _loadPosts();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }
}

// Calendar screen WITHOUT navbar
class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
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