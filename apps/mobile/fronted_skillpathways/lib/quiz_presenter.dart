import 'quiz_contract.dart';
import 'quiz_model.dart';

class QuizPresenterImpl implements QuizPresenter {
  final QuizView view;
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  Map<String, int> _pathwayScores = {};
  int? _selectedOptionIndex;

  QuizPresenterImpl(this.view);

  @override
  void loadQuiz() {
    // Mock questions
    _questions = [
      Question(prompt: "Which field interests you more?", options: [
        Option(text: "App Development", pathwayAssociated: "Development"),
        Option(text: "Data Analysis", pathwayAssociated: "Data"),
      ]),
      // ... add more questions
    ];
    _viewCurrentQuestion();
  }

  void _viewCurrentQuestion() {
    view.onQuestionUpdated(_questions[_currentQuestionIndex], _currentQuestionIndex, _questions.length);
    view.updateProgress((_currentQuestionIndex + 1) / _questions.length);
  }

  @override
  void selectOption(int optionIndex) {
    _selectedOptionIndex = optionIndex;
  }

  @override
  void nextQuestion() {
    if (_selectedOptionIndex != null) {
      final selectedOption = _questions[_currentQuestionIndex].options[_selectedOptionIndex!];
      _pathwayScores[selectedOption.pathwayAssociated] = (_pathwayScores[selectedOption.pathwayAssociated] ?? 0) + 1;

      _currentQuestionIndex++;
      if (_currentQuestionIndex < _questions.length) {
        _selectedOptionIndex = null;
        _viewCurrentQuestion();
      } else {
        _finishQuiz();
      }
    }
  }

  void _finishQuiz() {
    // Logic to find max score
    String recommended = _pathwayScores.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    view.onQuizCompleted(QuizResult(recommendedPathway: recommended, description: "Based on your interests..."));
  }

  @override
  void restartQuiz() {
    _currentQuestionIndex = 0;
    _pathwayScores.clear();
    _selectedOptionIndex = null;
    loadQuiz();
  }
}
