class GapAnalysisItem {
  final String stageTitle;
  final List<String> completedSkills;
  final List<String> missingSkills;
  final List<String> recommendedCourses; // List of Course IDs

  GapAnalysisItem({
    required this.stageTitle,
    required this.completedSkills,
    required this.missingSkills,
    required this.recommendedCourses,
  });
}
