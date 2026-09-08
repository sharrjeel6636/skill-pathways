import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'quiz_contract.dart';
import 'quiz_model.dart';
import 'quiz_presenter.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> implements QuizView {
  late QuizPresenter _presenter;
  Question? _currentQuestion;
  int _currentIndex = 0;
  int _totalQuestions = 0;
  double _progress = 0.0;
  int? _selectedOptionIndex;

  @override
  void initState() {
    super.initState();
    _presenter = QuizPresenterImpl(this);
    _presenter.loadQuiz();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentQuestion == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: QuizColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildProgressBar(),
            Expanded(flex: 3, child: _buildQuestionSection()),
            Expanded(flex: 7, child: _buildOptionsSection()),
            _buildBottomCTA(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() => Container(
    height: 60,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Row(
      children: [
        IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back)),
        const Chip(label: Text("Interest Assessment")),
        const Spacer(),
        Text("Question ${_currentIndex + 1} of $_totalQuestions", style: GoogleFonts.poppins()),
      ],
    ),
  );

  Widget _buildProgressBar() => LinearProgressIndicator(
    value: _progress,
    backgroundColor: QuizColors.borderIdle,
    valueColor: const AlwaysStoppedAnimation(QuizColors.primaryDark),
  );

  Widget _buildQuestionSection() => Container(
    padding: const EdgeInsets.all(24),
    child: Center(
      child: Text(
        _currentQuestion!.prompt,
        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: QuizColors.textPrimary),
        textAlign: TextAlign.center,
      ),
    ),
  );

  Widget _buildOptionsSection() => ListView.separated(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    itemCount: _currentQuestion!.options.length,
    separatorBuilder: (_, __) => const SizedBox(height: 12),
    itemBuilder: (context, index) {
      final isSelected = _selectedOptionIndex == index;
      return GestureDetector(
        onTap: () {
          setState(() {
            _selectedOptionIndex = index;
            _presenter.selectOption(index);
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? QuizColors.selectedBackground : QuizColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? QuizColors.primaryDark : QuizColors.borderIdle,
              width: isSelected ? 2 : 1.5,
            ),
          ),
          child: Row(
            children: [
              Expanded(child: Text(_currentQuestion!.options[index].text, style: GoogleFonts.poppins())),
              if (isSelected) const Icon(Icons.check_circle, color: QuizColors.primaryDark),
            ],
          ),
        ),
      );
    },
  );

  Widget _buildBottomCTA() => Container(
    height: 80,
    padding: const EdgeInsets.all(16),
    child: ElevatedButton(
      onPressed: _selectedOptionIndex == null ? null : () => _presenter.nextQuestion(),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        backgroundColor: QuizColors.primaryDark,
      ),
      child: Text(_currentIndex == _totalQuestions - 1 ? "Finish" : "Next Question", style: GoogleFonts.poppins(color: Colors.white)),
    ),
  );

  @override
  void onQuestionUpdated(Question question, int currentIndex, int totalQuestions) {
    setState(() {
      _currentQuestion = question;
      _currentIndex = currentIndex;
      _totalQuestions = totalQuestions;
      _selectedOptionIndex = null;
    });
  }

  @override
  void onQuizCompleted(QuizResult result) {
    // Navigate to Result Screen
  }

  @override
  void updateProgress(double progress) {
    setState(() => _progress = progress);
  }
}
