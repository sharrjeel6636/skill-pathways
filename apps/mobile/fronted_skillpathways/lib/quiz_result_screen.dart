import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'quiz_model.dart';

class QuizResultScreen extends StatelessWidget {
  final QuizResult result;
  final VoidCallback onRetake;
  final VoidCallback onViewRoadmap;

  const QuizResultScreen({
    super.key,
    required this.result,
    required this.onRetake,
    required this.onViewRoadmap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QuizColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(flex: 3, child: _buildTopArea()),
            Expanded(flex: 5, child: _buildRecommendationCard()),
            Expanded(flex: 2, child: _buildActionArea()),
          ],
        ),
      ),
    );
  }

  Widget _buildTopArea() => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: QuizColors.warmAccent.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.emoji_events, size: 48, color: QuizColors.warmAccent),
      ),
      const SizedBox(height: 16),
      Text(
        result.recommendedPathway,
        style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: QuizColors.textPrimary),
      ),
    ],
  );

  Widget _buildRecommendationCard() => Container(
    margin: const EdgeInsets.symmetric(horizontal: 24),
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: QuizColors.surface,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 16, offset: const Offset(0, 4))],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Your Top Recommendation", style: GoogleFonts.poppins(color: QuizColors.textSecondary)),
        const SizedBox(height: 16),
        Text(result.recommendedPathway, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Text(result.description, style: GoogleFonts.poppins(color: QuizColors.textSecondary)),
        // Placeholder for breakdown bars
      ],
    ),
  );

  Widget _buildActionArea() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    child: Column(
      children: [
        ElevatedButton(
          onPressed: onViewRoadmap,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            backgroundColor: QuizColors.primaryDark,
          ),
          child: Text("View Suggested Roadmap", style: GoogleFonts.poppins(color: Colors.white)),
        ),
        TextButton(
          onPressed: onRetake,
          child: Text("Retake Quiz", style: GoogleFonts.poppins(color: QuizColors.textSecondary)),
        ),
      ],
    ),
  );
}
