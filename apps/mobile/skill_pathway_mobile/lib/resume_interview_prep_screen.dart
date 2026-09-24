import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'chatbot_screen.dart';

enum PrepToolType { resumeTemplates, linkedinGuide, interviewQuestions, mockInterview }

class PrepTool {
  final String title;
  final String subtitle;
  final PrepToolType type;
  final IconData icon;

  PrepTool({
    required this.title,
    required this.subtitle,
    required this.type,
    required this.icon,
  });
}

class ResumeInterviewPrepScreen extends StatelessWidget {
  ResumeInterviewPrepScreen({super.key});

  final List<PrepTool> tools = [
    PrepTool(
      title: "Resume Templates",
      subtitle: "Pick a template and fill in your details",
      type: PrepToolType.resumeTemplates,
      icon: Icons.description_outlined,
    ),
    PrepTool(
      title: "LinkedIn Profile Guide",
      subtitle: "Build a strong professional presence",
      type: PrepToolType.linkedinGuide,
      icon: Icons.work_outline,
    ),
    PrepTool(
      title: "Common Interview Questions",
      subtitle: "Practice answers for entry-level roles",
      type: PrepToolType.interviewQuestions,
      icon: Icons.question_answer_outlined,
    ),
    PrepTool(
      title: "Mock Interview with Chatbot",
      subtitle: "Get instant feedback on your answers",
      type: PrepToolType.mockInterview,
      icon: Icons.chat_bubble_outline,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RoadmapColors.bgLight,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
              itemCount: tools.length,
              separatorBuilder: (ctx, index) => const SizedBox(height: 16),
              itemBuilder: (ctx, index) => _buildToolCard(context, tools[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() => Container(
        padding: const EdgeInsets.fromLTRB(24, 56, 24, 16),
        decoration: const BoxDecoration(color: RoadmapColors.surfaceWhite),
        width: double.infinity,
        child: Text("Resume & Interview Prep",
            style: GoogleFonts.inter(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: RoadmapColors.textDark)),
      );

  Widget _buildToolCard(BuildContext context, PrepTool tool) => GestureDetector(
        onTap: () => _handleTap(context, tool),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: RoadmapColors.surfaceWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: RoadmapColors.borderLight),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: RoadmapColors.lightTeal,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(tool.icon, color: RoadmapColors.primaryTeal, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tool.title,
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: RoadmapColors.textDark)),
                    const SizedBox(height: 3),
                    Text(tool.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                            fontSize: 11,
                            color: RoadmapColors.textMuted)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  void _handleTap(BuildContext context, PrepTool tool) {
    switch (tool.type) {
      case PrepToolType.resumeTemplates:
        context.push('/resume-templates');
        break;
      case PrepToolType.linkedinGuide:
        context.push('/linkedin-guide');
        break;
      case PrepToolType.interviewQuestions:
        context.push('/interview-questions');
        break;
      case PrepToolType.mockInterview:
        context.push('/chatbot', extra: {'isMockInterview': true});
        break;
    }
  }
}
