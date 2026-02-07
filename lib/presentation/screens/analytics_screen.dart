import 'package:flutter/material.dart';
import 'package:coco_app/core/constants/colors.dart';
import 'package:coco_app/core/constants/text_styles.dart';
import 'package:coco_app/core/widgets/custom_card.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String selectedPlatform = 'Instagram';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Your Statistics',
              style: AppTextStyles.heading1,
            ),
            const SizedBox(height: 24),

            // Platform Selector Dropdown
            _buildPlatformSelector(),
            const SizedBox(height: 24),

            // Stats Cards Row
            Row(
              children: [
                Expanded(
                  child: _buildGrowthRateCard(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildLatestPostCard(),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Followers Chart Card
            _buildFollowersChart(),
            const SizedBox(height: 24),

            // Convert to Value Card
            _buildConvertCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButton<String>(
        value: selectedPlatform,
        isExpanded: true,
        underline: const SizedBox(),
        icon: const Icon(Icons.keyboard_arrow_down),
        style: AppTextStyles.body,
        items: ['Instagram', 'Facebook', 'LinkedIn', 'TikTok']
            .map((platform) => DropdownMenuItem(
          value: platform,
          child: Text(platform),
        ))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              selectedPlatform = value;
            });
          }
        },
      ),
    );
  }

  Widget _buildGrowthRateCard() {
    return CustomCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Icon(
            Icons.trending_up,
            color: AppColors.primary,
            size: 32,
          ),
          const SizedBox(height: 12),
          Text(
            '3.80%',
            style: AppTextStyles.heading1.copyWith(
              fontSize: 28,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Followers Growth Rate',
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "That's a 17% increase from last week!",
            style: AppTextStyles.caption.copyWith(
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLatestPostCard() {
    return CustomCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Latest Post',
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: AppColors.success,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Centered circular progress
          Center(
            child: SizedBox(
              width: 90,
              height: 90,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const SizedBox(
                    width: 90,
                    height: 90,
                    child: CircularProgressIndicator(
                      value: 0.65,
                      strokeWidth: 8,
                      backgroundColor: AppColors.border,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Views',
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '2.5k',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowersChart() {
    return CustomCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Followers',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 24),

          // Chart area
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                // Y-axis labels
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 20,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildYAxisLabel('35k'),
                      _buildYAxisLabel('33k'),
                      _buildYAxisLabel('31k'),
                      _buildYAxisLabel('29k'),
                      _buildYAxisLabel('27k'),
                      _buildYAxisLabel('25k'),
                      _buildYAxisLabel('23k'),
                    ],
                  ),
                ),

                // Chart area with line
                Positioned(
                  left: 40,
                  right: 0,
                  top: 0,
                  bottom: 20,
                  child: CustomPaint(
                    painter: LineChartPainter(),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // X-axis labels
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildXAxisLabel('20 Nov'),
                _buildXAxisLabel('26 Nov'),
                _buildXAxisLabel('01 Dec'),
                _buildXAxisLabel('06 Dec'),
                _buildXAxisLabel('11 Dec'),
                _buildXAxisLabel('16 Dec'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYAxisLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(fontSize: 10),
      ),
    );
  }

  Widget _buildXAxisLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.caption.copyWith(fontSize: 10),
    );
  }

  Widget _buildConvertCard() {
    return CustomCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Let's convert this to more value",
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'View our feedback and recommendations based on your statistics.',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
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
        ],
      ),
    );
  }
}

// Custom painter for the line chart
class LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Define chart points (simulating follower growth from 25k to 33k)
    final points = [
      Offset(0, size.height * 0.85),              // 25k - Nov 20
      Offset(size.width * 0.2, size.height * 0.75), // 26k - Nov 26
      Offset(size.width * 0.4, size.height * 0.65), // 27k - Dec 01
      Offset(size.width * 0.6, size.height * 0.55), // 28k - Dec 06
      Offset(size.width * 0.8, size.height * 0.35), // 31k - Dec 11
      Offset(size.width, size.height * 0.2),       // 33k - Dec 16
    ];

    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 1; i < points.length; i++) {
      final previous = points[i - 1];
      final current = points[i];

      final controlPoint1 = Offset(
        previous.dx + (current.dx - previous.dx) / 3,
        previous.dy,
      );
      final controlPoint2 = Offset(
        previous.dx + 2 * (current.dx - previous.dx) / 3,
        current.dy,
      );

      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        current.dx,
        current.dy,
      );
    }

    canvas.drawPath(path, paint);

    // Draw dots at data points
    final dotPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    final dotBorderPaint = Paint()
      ..color = AppColors.cardBackground
      ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, 5, dotBorderPaint);
      canvas.drawCircle(point, 4, dotPaint);
    }

    // Draw horizontal grid lines
    final gridPaint = Paint()
      ..color = AppColors.border.withOpacity(0.3)
      ..strokeWidth = 1;

    for (int i = 0; i <= 6; i++) {
      final y = size.height * i / 6;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}