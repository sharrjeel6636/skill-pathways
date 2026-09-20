import 'quiz_contract.dart';
import 'quiz_model.dart';

class QuizPresenterImpl implements QuizPresenter {
  final QuizView view;
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  List<int?> _selectedOptions = [];

  QuizPresenterImpl(this.view);

  @override
  void loadQuiz() {
    _questions = [
      Question(
        prompt: "In your free time, what kind of activities do you enjoy most?",
        options: [
          Option(text: "Conducting mini experiments, coding, or fixing gadgets", pathwayAssociated: "Science"),
          Option(text: "Managing pocket money, starting small sales, or planning events", pathwayAssociated: "Commerce"),
          Option(text: "Sketching, writing stories, playing music, or theater", pathwayAssociated: "Arts"),
        ],
      ),
      Question(
        prompt: "Which of these school subjects excites you the most?",
        options: [
          Option(text: "Mathematics, Physics, Chemistry, or Biology", pathwayAssociated: "Science"),
          Option(text: "Accounting, Business Studies, or Economics", pathwayAssociated: "Commerce"),
          Option(text: "History, Literature, Fine Arts, or Civics", pathwayAssociated: "Arts"),
        ],
      ),
      Question(
        prompt: "If you were to build a mobile app, what would be your focus?",
        options: [
          Option(text: "Developing the algorithm, database, and logic", pathwayAssociated: "Science"),
          Option(text: "Creating the business model, marketing, and monetization plan", pathwayAssociated: "Commerce"),
          Option(text: "Designing the user interface, illustrations, and copywriting", pathwayAssociated: "Arts"),
        ],
      ),
      Question(
        prompt: "When working on a group project, which role do you naturally take?",
        options: [
          Option(text: "The technical expert who solves complex problems", pathwayAssociated: "Science"),
          Option(text: "The coordinator who keeps track of resources and timelines", pathwayAssociated: "Commerce"),
          Option(text: "The creative director who designs the presentation and style", pathwayAssociated: "Arts"),
        ],
      ),
      Question(
        prompt: "What kind of books or documentary topics do you search for?",
        options: [
          Option(text: "Space exploration, medical breakthroughs, or coding", pathwayAssociated: "Science"),
          Option(text: "Stock markets, successful startups, or economic policies", pathwayAssociated: "Commerce"),
          Option(text: "Art history, psychology, poetry, or philosophy", pathwayAssociated: "Arts"),
        ],
      ),
      Question(
        prompt: "How do you prefer to solve a difficult challenge?",
        options: [
          Option(text: "Using scientific methods, logical analysis, and testing data", pathwayAssociated: "Science"),
          Option(text: "Calculating costs, benefits, risks, and efficiency", pathwayAssociated: "Commerce"),
          Option(text: "Brainstorming creative angles, storytelling, and empathy", pathwayAssociated: "Arts"),
        ],
      ),
      Question(
        prompt: "Which of these careers sounds most appealing to you?",
        options: [
          Option(text: "Software Engineer, Doctor, or Research Scientist", pathwayAssociated: "Science"),
          Option(text: "Chartered Accountant, Marketing Manager, or Entrepreneur", pathwayAssociated: "Commerce"),
          Option(text: "Graphic Designer, Journalist, or Psychologist", pathwayAssociated: "Arts"),
        ],
      ),
      Question(
        prompt: "If you visited an exhibition, which pavilion would you spend hours in?",
        options: [
          Option(text: "Robotics, futuristic tech, and medical science gadgets", pathwayAssociated: "Science"),
          Option(text: "E-commerce trends, franchise setups, and modern trade", pathwayAssociated: "Commerce"),
          Option(text: "Paintings, sculpture, photography, and cultural crafts", pathwayAssociated: "Arts"),
        ],
      ),
      Question(
        prompt: "When you look at a successful business, what interests you most?",
        options: [
          Option(text: "The engineering/technology behind their product", pathwayAssociated: "Science"),
          Option(text: "The financial growth, revenue model, and scale", pathwayAssociated: "Commerce"),
          Option(text: "The branding, advertising campaigns, and emotional appeal", pathwayAssociated: "Arts"),
        ],
      ),
      Question(
        prompt: "What skill are you most eager to learn next?",
        options: [
          Option(text: "Data science, artificial intelligence, or lab procedures", pathwayAssociated: "Science"),
          Option(text: "Financial planning, digital marketing, or public speaking", pathwayAssociated: "Commerce"),
          Option(text: "Creative writing, UI/UX design, or film editing", pathwayAssociated: "Arts"),
        ],
      ),
    ];

    _currentQuestionIndex = 0;
    _selectedOptions = List.filled(_questions.length, null);
    _viewCurrentQuestion();
  }

  void _viewCurrentQuestion() {
    view.onQuestionUpdated(
      _questions[_currentQuestionIndex],
      _currentQuestionIndex,
      _questions.length,
      _selectedOptions[_currentQuestionIndex],
    );
    view.updateProgress((_currentQuestionIndex + 1) / _questions.length);
  }

  @override
  void selectOption(int optionIndex) {
    _selectedOptions[_currentQuestionIndex] = optionIndex;
    _viewCurrentQuestion();
  }

  @override
  void nextQuestion() {
    if (_selectedOptions[_currentQuestionIndex] != null) {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _viewCurrentQuestion();
      } else {
        _finishQuiz();
      }
    }
  }

  @override
  void previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      _viewCurrentQuestion();
    }
  }

  void _finishQuiz() {
    Map<String, int> scores = {"Science": 0, "Commerce": 0, "Arts": 0};
    for (int i = 0; i < _questions.length; i++) {
      final selectedIdx = _selectedOptions[i];
      if (selectedIdx != null) {
        final pathway = _questions[i].options[selectedIdx].pathwayAssociated;
        scores[pathway] = (scores[pathway] ?? 0) + 1;
      }
    }

    String recommended = "Science";
    int maxScore = -1;
    scores.forEach((pathway, score) {
      if (score > maxScore) {
        maxScore = score;
        recommended = pathway;
      }
    });

    String description = "";
    if (recommended == "Science") {
      description = "Based on your strong inclination towards logical problem solving, technology, and understanding physical world phenomena.";
    } else if (recommended == "Commerce") {
      description = "Based on your interest in business structures, financial management, economics, and analytical resource planning.";
    } else {
      description = "Based on your affinity for artistic expression, humanities, creative writing, and human-centric design.";
    }

    final result = QuizResult(
      recommendedPathway: recommended,
      description: description,
      scores: scores,
      totalQuestions: _questions.length,
    );

    // Save globally so HomeScreen can read it
    QuizState.completedResult = result;

    view.onQuizCompleted(result);
  }

  @override
  void restartQuiz() {
    _currentQuestionIndex = 0;
    _selectedOptions = List.filled(_questions.length, null);
    loadQuiz();
  }
}
