import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'shared_data.dart';
import 'chatbot_screen.dart';

class ResumeInterviewPrepScreen extends StatelessWidget {
  const ResumeInterviewPrepScreen({super.key});

  final List<PrepTool> _tools = const [
    PrepTool(title: "Resume Templates", subtitle: "Pick a template and fill in your details", type: PrepToolType.resumeTemplates, icon: Icons.description_outlined),
    PrepTool(title: "LinkedIn Profile Guide", subtitle: "Build a strong professional presence", type: PrepToolType.linkedinGuide, icon: Icons.business_center_outlined),
    PrepTool(title: "Common Interview Questions", subtitle: "Practice answers for entry-level roles", type: PrepToolType.interviewQuestions, icon: Icons.question_answer_outlined),
    PrepTool(title: "Mock Interview with Chatbot", subtitle: "Get instant feedback on your answers", type: PrepToolType.mockInterview, icon: Icons.smart_toy_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RoadmapColors.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                child: Column(
                  children: _tools.map((tool) => _buildToolCard(context, tool)).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() => Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(24, 56, 24, 16),
    decoration: const BoxDecoration(color: RoadmapColors.surfaceWhite),
    child: Text("Resume & Interview Prep",
        style: GoogleFonts.inter(fontSize: 19, fontWeight: FontWeight.bold, color: RoadmapColors.textDark)),
  );

  Widget _buildToolCard(BuildContext context, PrepTool tool) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: GestureDetector(
      onTap: () {
        if (tool.type == PrepToolType.mockInterview) {
          // Re-use ChatbotScreen with flag
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatbotScreen(isMockInterview: true)));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${tool.title} feature coming soon!")));
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: RoadmapColors.surfaceWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: RoadmapColors.borderLight),
        ),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(color: RoadmapColors.lightTeal, borderRadius: BorderRadius.circular(12)),
              child: Icon(tool.icon, color: RoadmapColors.primaryTeal),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tool.title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: RoadmapColors.textDark)),
                  const SizedBox(height: 3),
                  Text(tool.subtitle, style: GoogleFonts.inter(fontSize: 11, color: RoadmapColors.textMuted), maxLines: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
