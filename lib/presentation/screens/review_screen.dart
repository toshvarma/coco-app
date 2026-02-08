import 'package:flutter/material.dart';
import 'package:coco_app/core/constants/text_styles.dart';
import 'package:coco_app/core/widgets/custom_card.dart';
import 'package:coco_app/domain/models/review_model.dart';

class ReviewScreen extends StatelessWidget {
  final ReviewData reviewData;

  const ReviewScreen({
    super.key,
    required this.reviewData,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text('Your Review'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Card
              _buildGreetingCard(context),
              const SizedBox(height: 16),

              // Review Sections
              ...(reviewData.sections.map((section) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildReviewSection(context, section),
              ))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CustomCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.star_rounded,
              color: colorScheme.primary,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              reviewData.greeting,
              style: AppTextStyles.heading3.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewSection(BuildContext context, ReviewSection section) {
    final colorScheme = Theme.of(context).colorScheme;

    return CustomCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                section.emoji,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  section.title,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...section.points.map((point) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    point,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colorScheme.onSurface,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}