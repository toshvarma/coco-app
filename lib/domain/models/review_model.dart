class ReviewSection {
  final String title;
  final String emoji;
  final List<String> points;

  ReviewSection({
    required this.title,
    required this.emoji,
    required this.points,
  });
}

class ReviewData {
  final String greeting;
  final List<ReviewSection> sections;

  ReviewData({
    required this.greeting,
    required this.sections,
  });
}