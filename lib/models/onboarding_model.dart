// Simple data class to hold each onboarding slide's content
class OnboardingModel {
  final String title;
  final String description;
  final String imagePath; // asset path or icon

  OnboardingModel({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}