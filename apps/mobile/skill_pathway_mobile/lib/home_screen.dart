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
              const SizedBox(height: AppSpacing.p16),
              GestureDetector(
                onTap: () => context.push('/scholarship-info'),
                child: Row(
                  children: [
                    const Icon(Icons.school_outlined, size: 18, color: AppColors.textSecondary),
                    const SizedBox(width: AppSpacing.p8),
                    Text("Explore scholarships", style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
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
          Text(context.watch<ProfileProvider>().name, style: AppTextStyles.h1.copyWith(color: AppColors.textPrimary)),
        ],
      );

  Widget _buildSectionLabel(String title) => Text(title, style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary));

  Widget _buildQuizCTA(BuildContext context) {
    final quizCompleted = context.watch<QuizStateProvider>().completedResult != null;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.p24),
      decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(AppSpacing.r16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Take your Aptitude Quiz", style: AppTextStyles.titleLarge.copyWith(color: AppColors.textPrimary)),
          const SizedBox(height: AppSpacing.p8),
          Text("Find out if Science, Arts or Commerce fits you best — 5 mins", style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
          const SizedBox(height: AppSpacing.p16),
          ElevatedButton(
            onPressed: () => quizCompleted ? context.go('/quiz/result') : context.go('/quiz'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.surface),
            child: Text(quizCompleted ? "See Results" : "Start Quiz Now →"),
          ),
        ],
      ),
    );
  }

  Widget _buildRoadmapPreview(BuildContext context) {
    // NOTE: Roadmap preview is currently static example content, not live student data.
    final steps = [
        {"title": "Aptitude test completed", "subtitle": "Result: Pre-Engineering fit", "status": "done"},
        {"title": "Strengthen Math & Physics", "subtitle": "Recommended resources inside", "status": "locked"},
        {"title": "Explore Intermediate options", "subtitle": "FSc Pre-Engineering vs ICS", "status": "locked"},
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(step['title'] as String, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                    Text(step['subtitle'] as String, style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
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
      title: Text("For Your Parents", style: AppTextStyles.titleSmall),
      subtitle: Text("Share progress report with parents", style: AppTextStyles.bodySmall),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.go('/parent-dashboard'),
    ),
  );

  Widget _buildSuccessStoryCard() => Container(
    padding: const EdgeInsets.all(AppSpacing.p16),
    decoration: BoxDecoration(color: AppColors.lightTeal, borderRadius: BorderRadius.circular(AppSpacing.r12)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("“Matric ke baad confuse thi, ab NUST mein CS kar rahi hoon”", style: AppTextStyles.bodyMedium.copyWith(fontStyle: FontStyle.italic)),
        const SizedBox(height: AppSpacing.p8),
        Text("— Zainab, Karachi · BS Computer Science", style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
      ],
    ),
  );
}
