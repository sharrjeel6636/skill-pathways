import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'providers/QuizStateProvider.dart';
import 'providers/RoadmapProvider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RoadmapColors.bgLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildQuizCTA(context),
              const SizedBox(height: 24),
              _buildRoadmapPreview(context),
              const SizedBox(height: 24),
              _buildScholarshipCTA(context),
              const SizedBox(height: 24),
              _buildParentCard(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: RoadmapColors.primaryTeal,
        unselectedItemColor: RoadmapColors.textMuted,
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) context.go('/roadmap');
          else if (index == 2) context.go('/chatbot');
          else if (index == 3) context.go('/profile');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Roadmap'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildHeader() => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: const BoxDecoration(color: RoadmapColors.primaryTeal, borderRadius: BorderRadius.vertical(bottom: Radius.circular(16))),
        child: Column(
          children: [
            Text("Assalam-o-Alaikum, Student", style: GoogleFonts.inter(fontSize: 16, color: RoadmapColors.surfaceWhite)),
            const SizedBox(height: 4),
            Text("Matric · Pre-Engineering", style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: RoadmapColors.surfaceWhite)),
          ],
        ),
      );

  Widget _buildQuizCTA(BuildContext context) {
    final quizCompleted = context.watch<QuizStateProvider>().quizCompleted;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: RoadmapColors.accentAmber, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(quizCompleted ? "Quiz completed" : "Take your Aptitude Quiz", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: RoadmapColors.textOnAmber)),
          const SizedBox(height: 8),
          Text(quizCompleted ? "See your results and matched pathways." : "Discover your strengths and best-fit careers.", style: GoogleFonts.inter(fontSize: 13, color: RoadmapColors.textOnAmber)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => quizCompleted ? context.go('/quiz/result') : context.go('/quiz'),
            style: ElevatedButton.styleFrom(backgroundColor: RoadmapColors.textDark, foregroundColor: Colors.white),
            child: Text(quizCompleted ? "See Results →" : "Start Quiz Now →"),
          ),
        ],
      ),
    );
  }

  Widget _buildRoadmapPreview(BuildContext context) {
    final steps = context.watch<RoadmapProvider>().nextSteps;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: RoadmapColors.borderLight)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Your Roadmap", style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: RoadmapColors.textDark)),
          const SizedBox(height: 12),
          ...steps.take(2).map((step) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text("• $step", style: GoogleFonts.inter(fontSize: 13, color: RoadmapColors.textMuted)))),
          const SizedBox(height: 12),
          GestureDetector(onTap: () => context.go('/roadmap'), child: Text("View full roadmap →", style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: RoadmapColors.primaryTeal))),
        ],
      ),
    );
  }

  Widget _buildParentCard(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(color: RoadmapColors.lightTeal, borderRadius: BorderRadius.circular(16)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("For Your Parents", style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: RoadmapColors.textDark)),
        const SizedBox(height: 8),
        Text("Share your progress and help them stay informed.", style: GoogleFonts.inter(fontSize: 13, color: RoadmapColors.textMuted)),
        const SizedBox(height: 16),
        ElevatedButton(onPressed: () => context.go('/profile'), child: const Text("Link Parent Account")),
      ],
    ),
  );

  Widget _buildScholarshipCTA(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: RoadmapColors.borderLight)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Scholarship Opportunities", style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: RoadmapColors.textDark)),
        const SizedBox(height: 8),
        Text("Browse available scholarships based on your profile.", style: GoogleFonts.inter(fontSize: 13, color: RoadmapColors.textMuted)),
        const SizedBox(height: 16),
        ElevatedButton(onPressed: () => context.go('/scholarship-info'), child: const Text("View Scholarships →")),
      ],
    ),
  );
}
