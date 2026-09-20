import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'quiz_contract.dart';
import 'quiz_model.dart';
import 'quiz_presenter.dart';
import 'quiz_result_screen.dart';

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
    if (_currentQuestion == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFFAFAF7),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF0B766F)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF7),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            _buildProgressBar(),
            const SizedBox(height: 16),
            _buildQuestionSection(),
            const SizedBox(height: 16),
            Expanded(
              child: _buildOptionsSection(),
            ),
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
        IconButton(
          onPressed: () {
            if (_currentIndex > 0) {
              _presenter.previousQuestion();
            } else {
              Navigator.pop(context);
            }
          },
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E2022)),
        ),
        const Chip(
          label: Text("Interest Assessment"),
          backgroundColor: Color(0xFFE9F5F3),
          labelStyle: TextStyle(
            color: Color(0xFF0B766F),
            fontWeight: FontWeight.bold,
            fontSize: 12,
            fontFamily: 'Inter',
          ),
          side: BorderSide.none,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
        ),
        const Spacer(),
        Text(
          "Question ${_currentIndex + 1} of $_totalQuestions",
          style: GoogleFonts.inter(
            color: const Color(0xFF7E8A87),
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ],
    ),
  );

  Widget _buildProgressBar() => PreferredSize(
    preferredSize: const Size.fromHeight(4),
    child: LinearProgressIndicator(
      value: _progress,
      backgroundColor: const Color(0xFFE5E7EB),
      valueColor: const AlwaysStoppedAnimation(Color(0xFF0B766F)),
    ),
  );

  Widget _buildQuestionSection() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    alignment: Alignment.center,
    child: Text(
      _currentQuestion!.prompt,
      style: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF1E2022),
        height: 1.3,
      ),
      textAlign: TextAlign.center,
    ),
  );

  Widget _buildOptionsSection() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(_currentQuestion!.options.length, (index) {
        final isSelected = _selectedOptionIndex == index;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedOptionIndex = index;
                _presenter.selectOption(index);
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFE9F5F3) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? const Color(0xFF0B766F) : const Color(0xFFE5E7EB),
                  width: isSelected ? 2 : 1.5,
                ),
                boxShadow: isSelected
                    ? [BoxShadow(color: const Color(0xFF0B766F).withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))]
                    : [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 4, offset: const Offset(0, 2))],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _currentQuestion!.options[index].text,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: const Color(0xFF1E2022),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildOptionCircle(isSelected),
                ],
              ),
            ),
          ),
        );
      }),
    ),
  );

  Widget _buildOptionCircle(bool isSelected) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? const Color(0xFF0B766F) : const Color(0xFFE5E7EB),
          width: 2,
        ),
        color: isSelected ? const Color(0xFF0B766F) : Colors.transparent,
      ),
      child: isSelected
          ? const Center(
              child: Icon(
                Icons.check,
                size: 14,
                color: Colors.white,
              ),
            )
          : null,
    );
  }

  Widget _buildBottomCTA() {
    final isOptionPicked = _selectedOptionIndex != null;
    return Container(
      padding: const EdgeInsets.all(24),
      child: GestureDetector(
        onTap: isOptionPicked ? () => _presenter.nextQuestion() : null,
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: isOptionPicked ? const Color(0xFF0B766F) : const Color(0xFFE5E7EB),
            borderRadius: BorderRadius.circular(16),
            boxShadow: isOptionPicked
                ? [BoxShadow(color: const Color(0xFF0B766F).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))]
                : [],
          ),
          child: Center(
            child: Text(
              _currentIndex == _totalQuestions - 1 ? "Finish" : "Next Question",
              style: GoogleFonts.inter(
                color: isOptionPicked ? Colors.white : const Color(0xFF9CA3AF),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void onQuestionUpdated(Question question, int currentIndex, int totalQuestions, int? selectedOptionIndex) {
    setState(() {
      _currentQuestion = question;
      _currentIndex = currentIndex;
      _totalQuestions = totalQuestions;
      _selectedOptionIndex = selectedOptionIndex;
    });
  }

  @override
  void onQuizCompleted(QuizResult result) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResultScreen(result: result),
      ),
    );
  }

  @override
  void updateProgress(double progress) {
    setState(() => _progress = progress);
  }
}
