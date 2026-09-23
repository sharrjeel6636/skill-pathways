import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/app_colors.dart';
import 'theme/app_spacing.dart';
import 'theme/app_text_styles.dart';
import 'quiz_contract.dart';
import 'quiz_model.dart';
import 'quiz_presenter.dart';
import 'quiz_result_screen.dart';
import 'widgets/async_state_view.dart';

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
  AsyncViewState _state = AsyncViewState.loading;

  @override
  void initState() {
    super.initState();
    _presenter = QuizPresenterImpl(this);
    _presenter.loadQuiz();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: AsyncStateView(
          state: _state,
          onRetry: _presenter.loadQuiz,
          errorMessage: "Couldn't load quiz. Please try again.",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              _buildProgressBar(),
              const SizedBox(height: AppSpacing.p24),
              if (_currentQuestion != null) ...[
                _buildQuestionSection(),
                const SizedBox(height: AppSpacing.p24),
                Expanded(
                  child: _buildOptionsSection(),
                ),
                _buildBottomCTA(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onQuizError() {
    setState(() => _state = AsyncViewState.error);
  }

  Widget _buildHeader() => Padding(
    padding: const EdgeInsets.all(AppSpacing.p16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        ),
        Text(
          "Question ${_currentIndex + 1} of $_totalQuestions",
          style: GoogleFonts.inter(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ],
    ),
  );

  Widget _buildProgressBar() => LinearProgressIndicator(
    value: _progress,
    backgroundColor: AppColors.border,
    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
  );

  Widget _buildQuestionSection() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.p24),
    child: Text(
      _currentQuestion!.prompt,
      style: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        height: 1.3,
      ),
      textAlign: TextAlign.center,
    ),
  );

  Widget _buildOptionsSection() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.p24),
    child: Column(
      children: List.generate(_currentQuestion!.options.length, (index) {
        final isSelected = _selectedOptionIndex == index;
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.p12),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedOptionIndex = index;
                _presenter.selectOption(index);
              });
            },
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.p16),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.lightTeal : AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.r12),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.background,
                      borderRadius: BorderRadius.circular(AppSpacing.r8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      String.fromCharCode(65 + index),
                      style: GoogleFonts.inter(
                        color: isSelected ? AppColors.surface : AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.p16),
                  Expanded(
                    child: Text(
                      _currentQuestion!.options[index].text,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    ),
  );

  Widget _buildBottomCTA() {
    final isOptionPicked = _selectedOptionIndex != null;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.p24),
      child: ElevatedButton(
        onPressed: isOptionPicked ? () => _presenter.nextQuestion() : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isOptionPicked ? AppColors.primary : AppColors.border,
          foregroundColor: AppColors.surface,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.p16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.r12)),
        ),
        child: Text(
          _currentIndex == _totalQuestions - 1 ? "Finish" : "Next Question",
          style: AppTextStyles.button,
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
      _state = AsyncViewState.data;
    });
  }

  @override
  void onQuizCompleted(QuizResult result) {
    context.pushReplacement('/quiz/result', extra: result);
  }

  @override
  void updateProgress(double progress) {
    setState(() => _progress = progress);
  }
}
