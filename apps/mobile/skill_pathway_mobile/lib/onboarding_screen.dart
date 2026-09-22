import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/app_colors.dart';
import 'theme/app_spacing.dart';
import 'theme/app_text_styles.dart';

class OnboardingScreen extends StatelessWidget {
  final Function(String) onLanguageConfirmed;
  const OnboardingScreen({super.key, required this.onLanguageConfirmed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.p24),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.p32),
              // Logo Placeholder / Brand Mark
              const Icon(Icons.school, size: 64, color: AppColors.primary),
              const SizedBox(height: AppSpacing.p24),
              // Title
              Text("Skill Pathway", style: AppTextStyles.titleLarge),
              const SizedBox(height: AppSpacing.p8),
              // Tagline
              Text("Matric se career tak, guided rasta", 
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
              const Spacer(),
              // Illustration area placeholder (can be expanded)
              Container(height: 120, color: AppColors.lightTeal),
              const Spacer(),
              // Language Selection
              Text("Choose your language", style: AppTextStyles.titleSmall),
              const SizedBox(height: AppSpacing.p16),
              _buildLanguageCard("English", () => onLanguageConfirmed("English"), isRtl: false),
              const SizedBox(height: AppSpacing.p12),
              _buildLanguageCard("اردو", () => onLanguageConfirmed("Urdu"), isRtl: true),
              const SizedBox(height: AppSpacing.p24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageCard(String language, VoidCallback onTap, {required bool isRtl}) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.p16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.r12),
        border: Border.all(color: AppColors.border),
      ),
      child: Center(
        child: Text(
          language,
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}
