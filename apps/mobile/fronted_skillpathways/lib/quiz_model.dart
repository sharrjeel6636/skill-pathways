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

  QuizResult({required this.recommendedPathway, required this.description});
}
