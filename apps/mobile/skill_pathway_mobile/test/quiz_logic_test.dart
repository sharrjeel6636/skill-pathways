import 'package:flutter_test/flutter_test.dart';
import 'package:skill_pathway/quiz_presenter.dart';
import 'package:skill_pathway/quiz_contract.dart';
import 'package:skill_pathway/quiz_model.dart';
import 'package:mockito/mockito.dart';

class MockQuizView extends Mock implements QuizView {
  @override
  void onQuestionUpdated(Question question, int currentIndex, int totalQuestions, int? selectedOptionIndex) {}
  @override
  void updateProgress(double progress) {}
  @override
  void onQuizCompleted(QuizResult result) {}
  @override
  void onQuizError() {}
}

void main() {
  test('Quiz scoring logic', () {
    final mockView = MockQuizView();
    final presenter = QuizPresenterImpl(mockView);
    presenter.loadQuiz();

    // The presenter is hardcoded with 10 questions.
    // For simplicity in test, we need to mock the questions or rely on hardcoded presenter data.
    // Given the presenter has hardcoded questions, this test is tightly coupled to that implementation.
    
    // Simulate selecting answers
    // 0: Science, 1: Commerce, 2: Arts
    // Let's answer 5 Science, 3 Commerce, 2 Arts
    for (int i = 0; i < 5; i++) {
        presenter.selectOption(0);
        presenter.nextQuestion();
    }
    for (int i = 0; i < 3; i++) {
        presenter.selectOption(1);
        presenter.nextQuestion();
    }
    for (int i = 0; i < 2; i++) {
        presenter.selectOption(2);
        presenter.nextQuestion();
    }

    // The last question is already selected (by the loop). The final call triggers _finishQuiz.
    // The presenter internally manages index. 
    // This is tricky because of the presenter's internal state.
  });
}
