import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'theme/app_colors.dart';
import 'theme/app_spacing.dart';
import 'theme/app_text_styles.dart';
import 'providers/QuizStateProvider.dart';
import 'providers/ProfileProvider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.p24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: AppSpacing.p24),
              _buildQuizCTA(context),
              const SizedBox(height: AppSpacing.p24),
              _buildSectionLabel("Your Roadmap"),
              const SizedBox(height: AppSpacing.p12),
              _buildRoadmapPreview(context),
              const SizedBox(height: AppSpacing.p24),
              _buildSectionLabel("For Your Parents"),
              const SizedBox(height: AppSpacing.p12),
              _buildParentCard(context),
              const SizedBox(height: AppSpacing.p24),
              _buildSectionLabel("Success Stories"),
              const SizedBox(height: AppSpacing.p12),
              _buildSuccessStoryCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) return; // Already on Home
          if (index == 1) context.go('/roadmap');
          else if (index == 2) context.go('/chatbot');
          else if (index == 3) context.go('/profile');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Roadmap'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chatbot'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Assalam-o-Alaikum", style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.p4),
          Text(context.watch<ProfileProvider>().name, style: AppTextStyles.headlineSmall.copyWith(color: AppColors.textPrimary)),
        ],
      );

  Widget _buildSectionLabel(String title) => Text(title, style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary));

  Widget _buildQuizCTA(BuildContext context) {
    final quizCompleted = context.watch<QuizStateProvider>().completedResult != null;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.p24),
      decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(AppSpacing.r16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Find Your Path", style: AppTextStyles.titleLarge.copyWith(color: AppColors.textPrimary)),
          const SizedBox(height: AppSpacing.p8),
          Text("Take the aptitude quiz to get your personalized roadmap.", style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
          const SizedBox(height: AppSpacing.p16),
          ElevatedButton(
            onPressed: () => quizCompleted ? context.go('/quiz/result') : context.go('/quiz'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.surface),
            child: Text(quizCompleted ? "See Results" : "Start Quiz"),
          ),
        ],
      ),
    );
  }

  Widget _buildRoadmapPreview(BuildContext context) {
    final steps = [
        {"title": "Interest Assessment", "status": "done"},
        {"title": "Pathway Selection", "status": "done"},
        {"title": "University Preparation", "status": "locked"},
    ];
    return Container(
      padding: const EdgeInsets.all(AppSpacing.p16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppSpacing.r16), border: Border.all(color: AppColors.border)),
      child: Column(
        children: steps.map((step) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.p12),
          child: Row(
            children: [
              Icon(step['status'] == 'done' ? Icons.check_circle : Icons.lock_outline, color: step['status'] == 'done' ? AppColors.success : AppColors.textSecondary),
              const SizedBox(width: AppSpacing.p12),
              Text(step['title'] as String, style: AppTextStyles.bodyMedium),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildParentCard(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.p16),
    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppSpacing.r12), border: Border.all(color: AppColors.border)),
    child: ListTile(
      leading: const Icon(Icons.family_restroom, color: AppColors.primary),
      title: Text("Parent Portal", style: AppTextStyles.titleSmall),
      subtitle: Text("Share progress and guidance with your parents", style: AppTextStyles.bodySmall),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.go('/parent-dashboard'),
    ),
  );

  Widget _buildSuccessStoryCard() => Container(
    padding: const EdgeInsets.all(AppSpacing.p16),
    decoration: BoxDecoration(color: AppColors.lightTeal, borderRadius: BorderRadius.circular(AppSpacing.r12)),
    child: Text("“The roadmap helped me decide my field confidently!” — Student", style: AppTextStyles.bodyMedium.copyWith(fontStyle: FontStyle.italic)),
  );
}
