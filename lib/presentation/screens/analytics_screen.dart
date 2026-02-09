import 'package:flutter/material.dart';
import 'package:coco_app/core/constants/text_styles.dart';
import 'package:coco_app/core/widgets/custom_card.dart';
import 'package:coco_app/presentation/screens/review_screen.dart';
import 'package:coco_app/data/services/review_service.dart';
import 'package:coco_app/data/services/auth_service.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String selectedPlatform = 'Instagram';

  final ReviewService _reviewService = ReviewService();
  final AuthService _authService = AuthService();

  String _personaId = 'lena';
  Map<String, dynamic> _userStats = {};

  @override
  void initState() {
    super.initState();
    _loadUserPersona();
  }

  Future<void> _loadUserPersona() async {
    final user = await _authService.getCurrentUser();
    if (user != null && mounted) {
      setState(() {
        if (user['email'] == 'mike@coco.com') {
          _personaId = 'mike';
          _userStats = _getMikeStats();
        } else {
          _personaId = 'lena';
          _userStats = _getLenaStats();
        }
      });
    }
  }

  Map<String, dynamic> _getLenaStats() {
    return {
      'growthRate': '3.80%',
      'growthIncrease': '17%',
      'latestPostViews': '2.5k',
      'posts': '12',
      'reach': '3.5k',
      'engagement': '24%',
      'chartPoints': [
        {'date': '20 Nov', 'value': 0.85, 'followers': '25k'},
        {'date': '26 Nov', 'value': 0.75, 'followers': '26k'},
        {'date': '01 Dec', 'value': 0.65, 'followers': '27k'},
        {'date': '06 Dec', 'value': 0.55, 'followers': '28k'},
        {'date': '11 Dec', 'value': 0.35, 'followers': '31k'},
        {'date': '16 Dec', 'value': 0.20, 'followers': '33k'},
      ],
      'yAxisLabels': ['35k', '33k', '31k', '29k', '27k', '25k', '23k'],
    };
  }

  Map<String, dynamic> _getMikeStats() {
    return {
      'growthRate': '5.20%',
      'growthIncrease': '23%',
      'latestPostViews': '4.8k',
      'posts': '18',
      'reach': '7.2k',
      'engagement': '31%',
      'chartPoints': [
        {'date': '20 Nov', 'value': 0.85, 'followers': '38k'},
        {'date': '26 Nov', 'value': 0.70, 'followers': '40k'},
        {'date': '01 Dec', 'value': 0.55, 'followers': '42k'},
        {'date': '06 Dec', 'value': 0.45, 'followers': '44k'},
        {'date': '11 Dec', 'value': 0.25, 'followers': '47k'},
        {'date': '16 Dec', 'value': 0.10, 'followers': '50k'},
      ],
      'yAxisLabels': ['52k', '50k', '47k', '44k', '42k', '40k', '38k'],
    };
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your Statistics', style: AppTextStyles.heading1),
            const SizedBox(height: 24),
            _buildPlatformSelector(),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _buildGrowthRateCard()),
                const SizedBox(width: 12),
                Expanded(child: _buildLatestPostCard()),
              ],
            ),
            const SizedBox(height: 24),
            _buildFollowersChart(),
            const SizedBox(height: 24),
            _buildConvertCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformSelector() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
      ),
      child: DropdownButton<String>(
        value: selectedPlatform,
        isExpanded: true,
        underline: const SizedBox(),
        items: ['Instagram', 'Facebook', 'LinkedIn']
            .map(
              (platform) => DropdownMenuItem(
            value: platform,
            child: Text(platform),
          ),
        )
            .toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() => selectedPlatform = value);
          }
        },
      ),
    );
  }

  Widget _buildGrowthRateCard() {
    final colorScheme = Theme.of(context).colorScheme;

    return CustomCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(Icons.trending_up, color: colorScheme.primary, size: 32),
          const SizedBox(height: 12),
          Text(
            _userStats['growthRate'] ?? '0%',
            style: AppTextStyles.heading1.copyWith(
              fontSize: 28,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "That's a ${_userStats['growthIncrease'] ?? '0%'} increase from last week!",
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLatestPostCard() {
    final colorScheme = Theme.of(context).colorScheme;

    return CustomCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text('Latest Post', style: AppTextStyles.bodySmall),
          const SizedBox(height: 24),
          Text(
            _userStats['latestPostViews'] ?? '0',
            style: AppTextStyles.heading3.copyWith(
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowersChart() {
    final colorScheme = Theme.of(context).colorScheme;

    final List<String> yAxisLabels =
    List<String>.from(_userStats['yAxisLabels'] ?? []);

    final List<Map<String, dynamic>> chartPoints =
    List<Map<String, dynamic>>.from(_userStats['chartPoints'] ?? []);

    return CustomCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Followers', style: AppTextStyles.heading3),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 20,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: yAxisLabels
                        .map((label) => _buildYAxisLabel(label))
                        .toList(),
                  ),
                ),
                Positioned(
                  left: 40,
                  right: 0,
                  top: 0,
                  bottom: 20,
                  child: CustomPaint(
                    painter: LineChartPainter(
                      primaryColor: colorScheme.primary,
                      surfaceColor: colorScheme.surface,
                      borderColor:
                      colorScheme.outline.withOpacity(0.3),
                      chartPoints: chartPoints,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: chartPoints
                  .map<Widget>(
                    (point) =>
                    _buildXAxisLabel(point['date'] as String),
              )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYAxisLabel(String text) =>
      Text(text, style: AppTextStyles.caption);

  Widget _buildXAxisLabel(String text) =>
      Text(text, style: AppTextStyles.caption);

  Widget _buildConvertCard() {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () {
        final reviewData =
        _reviewService.getReviewForUser(_personaId);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ReviewScreen(reviewData: reviewData),
          ),
        );
      },
      child: CustomCard(
        child: Row(
          children: [
            const Expanded(
              child: Text(
                "Let's convert this to more value",
                style: AppTextStyles.bodySmall,
              ),
            ),
            Icon(Icons.arrow_forward, color: colorScheme.primary),
          ],
        ),
      ),
    );
  }
}



class LineChartPainter extends CustomPainter {
  final Color primaryColor;
  final Color surfaceColor;
  final Color borderColor;
  final List<Map<String, dynamic>> chartPoints;

  LineChartPainter({
    required this.primaryColor,
    required this.surfaceColor,
    required this.borderColor,
    required this.chartPoints,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (chartPoints.isEmpty) return;

    final paint = Paint()
      ..color = primaryColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();

    final points = chartPoints.asMap().entries.map((entry) {
      final x =
          (size.width / (chartPoints.length - 1)) * entry.key;
      final y = size.height * (entry.value['value'] as double);
      return Offset(x, y);
    }).toList();

    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}
