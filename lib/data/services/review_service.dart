import '../../domain/models/review_model.dart';

class ReviewService {
  ReviewData getReviewForUser(String personaId) {
    switch (personaId) {
      case 'mike':
        return _mikeReview();
      case 'lena':
      default:
        return _lenaReview();
    }
  }

  ReviewData _lenaReview() {
    return ReviewData(
      greeting: "Let’s review your last 60 days, Lena",
      sections: [
        ReviewSection(
          title: "What’s working well",
          emoji: "✅",
          points: [
            "Instagram is your strongest platform",
            "Before/after posts perform best",
            "Consistent posting increased your reach",
          ],
        ),
        ReviewSection(
          title: "What needs adjusting",
          emoji: "⚠️",
          points: [
            "LinkedIn engagement is very low",
            "Some posts lack a clear takeaway",
          ],
        ),
        ReviewSection(
          title: "What to change next",
          emoji: "🔧",
          points: [
            "Add TikTok for short room transformations",
            "Post one practical tip per week",
            "Reuse Instagram content as short videos",
            "Reduce time spent on LinkedIn",
          ],
        ),
        ReviewSection(
          title: "Focus for the next 30 days",
          emoji: "🎯",
          points: [
            "Keep Instagram as your main platform",
            "Test TikTok with 1–2 posts per week",
            "Use COCO’s posting recommendations",
          ],
        ),
      ],
    );
  }

  ReviewData _mikeReview() {
    return ReviewData(
      greeting: "Let’s review your progress, Mike",
      sections: [
        ReviewSection(
          title: "Big improvements",
          emoji: "💪",
          points: [
            "Clear growth across all platforms",
            "Educational posts drive client inquiries",
          ],
        ),
        ReviewSection(
          title: "What to double down on",
          emoji: "🚀",
          points: [
            "LinkedIn performs well for your audience",
            "Newsletter strengthens client retention",
          ],
        ),
        ReviewSection(
          title: "Next focus",
          emoji: "🎯",
          points: [
            "Maintain posting rhythm",
            "Continue educational content",
          ],
        ),
      ],
    );
  }
}