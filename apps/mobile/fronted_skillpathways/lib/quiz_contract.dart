import 'quiz_model.dart';

abstract class QuizView {
  void onQuestionUpdated(Question question, int currentIndex, int totalQuestions, int? selectedOptionIndex);
  void onQuizCompleted(QuizResult result);
  void updateProgress(double progress);
}

abstract class QuizPresenter {
  void loadQuiz();
  void selectOption(int optionIndex);
  void nextQuestion();
  void previousQuestion();
  void restartQuiz();
}
