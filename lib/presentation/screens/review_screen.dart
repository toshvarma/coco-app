import 'package:flutter/material.dart';
import '../../data/services/review_service.dart';
import '../../domain/models/review_model.dart';

class ReviewScreen extends StatelessWidget {
  final String personaId;

  const ReviewScreen({
    super.key,
    required this.personaId,
  });

  @override
  Widget build(BuildContext context) {
    final ReviewData reviewData =
    ReviewService().getReviewForUser(personaId);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Let’s Review"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _GreetingCard(text: reviewData.greeting),
          const SizedBox(height: 16),
          ...reviewData.sections.map(
                (section) => _ReviewSectionCard(section: section),
          ),
        ],
      ),
    );
  }
}

class _GreetingCard extends StatelessWidget {
  final String text;

  const _GreetingCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}

class _ReviewSectionCard extends StatelessWidget {
  final ReviewSection section;

  const _ReviewSectionCard({required this.section});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${section.emoji} ${section.title}",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...section.points.map(
                  (point) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("• "),
                    Expanded(child: Text(point)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}