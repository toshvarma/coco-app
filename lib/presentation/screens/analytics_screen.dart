import 'package:flutter/material.dart';
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
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
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
        icon: const Icon(Icons.keyboard_arrow_down),
        style: AppTextStyles.body.copyWith(color: colorScheme.onSurface),
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
    final colorScheme = Theme.of(context).colorScheme;

    return CustomCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(
            Icons.trending_up,
            color: colorScheme.primary,
            size: 32,
          ),
          const SizedBox(height: 12),
          Text(
            '3.80%',
            style: AppTextStyles.heading1.copyWith(
              fontSize: 28,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Followers Growth Rate',
            style: AppTextStyles.caption.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "That's a 17% increase from last week!",
            style: AppTextStyles.caption.copyWith(
              fontSize: 11,
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Latest Post',
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: colorScheme.primary,
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
                  SizedBox(
                    width: 90,
                    height: 90,
                    child: CircularProgressIndicator(
                      value: 0.65,
                      strokeWidth: 8,
                      backgroundColor: colorScheme.outline.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.primary,
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
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '2.5k',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: colorScheme.onSurface,
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
    final colorScheme = Theme.of(context).colorScheme;

    return CustomCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Followers',
            style: AppTextStyles.heading3.copyWith(
              color: colorScheme.onSurface,
            ),
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
                    painter: LineChartPainter(
                      primaryColor: colorScheme.primary,
                      surfaceColor: colorScheme.surface,
                      borderColor: colorScheme.outline.withOpacity(0.3),
                    ),
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
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(
          fontSize: 10,
          color: colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
    );
  }

  Widget _buildXAxisLabel(String text) {
    final colorScheme = Theme.of(context).colorScheme;

    return Text(
      text,
      style: AppTextStyles.caption.copyWith(
        fontSize: 10,
        color: colorScheme.onSurface.withOpacity(0.6),
      ),
    );
  }

  Widget _buildConvertCard() {
    final colorScheme = Theme.of(context).colorScheme;

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
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'View our feedback and recommendations based on your statistics.',
                  style: AppTextStyles.caption.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.arrow_downward,
              color: colorScheme.primary,
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
  final Color primaryColor;
  final Color surfaceColor;
  final Color borderColor;

  LineChartPainter({
    required this.primaryColor,
    required this.surfaceColor,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor
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
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    final dotBorderPaint = Paint()
      ..color = surfaceColor
      ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, 5, dotBorderPaint);
      canvas.drawCircle(point, 4, dotPaint);
    }

    // Draw horizontal grid lines
    final gridPaint = Paint()
      ..color = borderColor
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