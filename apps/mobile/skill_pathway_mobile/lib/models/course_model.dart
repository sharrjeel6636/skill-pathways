class CourseDetail {
  final String title;
  final String platform;
  final String description;
  final List<String> learningPoints;
  final String externalUrl;
  final String? imageUrl;

  CourseDetail({
    required this.title,
    required this.platform,
    required this.description,
    required this.learningPoints,
    required this.externalUrl,
    this.imageUrl,
  });
}

class CourseListing {
  final String platform;
  final String title;
  final String level;
  final String durationLabel;
  final bool isFree;
  final List<String> tags; // e.g. ["Programming"], used for filter matching
  final CourseDetail detail;

  CourseListing({
    required this.platform,
    required this.title,
    required this.level,
    required this.durationLabel,
    required this.isFree,
    required this.tags,
    required this.detail,
  });
}

enum CertStatus { completed, inProgress, notStarted }
