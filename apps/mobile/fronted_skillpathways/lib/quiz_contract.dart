import 'quiz_model.dart';

abstract class QuizView {
  void onQuestionUpdated(Question question, int currentIndex, int totalQuestions);
  void onQuizCompleted(QuizResult result);
  void updateProgress(double progress);
}

abstract class QuizPresenter {
  void loadQuiz();
  void selectOption(int optionIndex);
  void nextQuestion();
  void restartQuiz();
}
