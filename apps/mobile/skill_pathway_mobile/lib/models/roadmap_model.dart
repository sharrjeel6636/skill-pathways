enum GrowthLevelStatus { active, next, locked }

class CareerGrowthLevel {
  final String title;
  final String subtitle;
  final GrowthLevelStatus status;

  CareerGrowthLevel({
    required this.title,
    required this.subtitle,
    required this.status,
  });
}
