class Option {
  final String text;
  final String pathwayAssociated;

  Option({required this.text, required this.pathwayAssociated});
}

class Question {
  final String prompt;
  final List<Option> options;

  Question({required this.prompt, required this.options});
}

class QuizResult {
  final String recommendedPathway;
  final String description;
  final Map<String, int> scores;
  final int totalQuestions;

  QuizResult({
    required this.recommendedPathway,
    required this.description,
    required this.scores,
    required this.totalQuestions,
  });

  String get topField => recommendedPathway;
}

class QuizState {
  static QuizResult? completedResult;
}

enum StageStatus { done, active, locked }

class RoadmapStage {
  final String title;
  final String subtitle;
  final StageStatus status;

  RoadmapStage({
    required this.title,
    required this.subtitle,
    required this.status,
  });
}

class ParentDashboardData {
  final String childName;
  final String fieldOfInterest;
  final String summaryText;
  final int roadmapProgressPercent;
  final bool quizCompleted;
  final String nextMilestoneLabel;

  ParentDashboardData({
    required this.childName,
    required this.fieldOfInterest,
    required this.summaryText,
    required this.roadmapProgressPercent,
    required this.quizCompleted,
    required this.nextMilestoneLabel,
  });
}
