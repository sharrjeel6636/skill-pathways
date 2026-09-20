import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chatbot_screen.dart';

class ParentDashboardData {
  final String childName;
  final String fieldOfInterest;
  final String summaryText;
  final int roadmapProgressPercent;
  final bool quizCompleted;
  final String nextMilestoneLabel;

  ParentDashboardData({
    required this.childName,
    required this.fieldOfInterest,
    required this.summaryText,
    required this.roadmapProgressPercent,
    required this.quizCompleted,
    required this.nextMilestoneLabel,
  });
}

class ParentDashboardScreen extends StatelessWidget {
  final ParentDashboardData data;

  const ParentDashboardScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RoadmapColors.bgLight,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryCard(),
                  const SizedBox(height: 18),
                  _buildStatsCard(),
                  const SizedBox(height: 18),
                  Text("Ask a Question",
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: RoadmapColors.textDark
                    )
                  ),
                  const SizedBox(height: 12),
                  _buildChatbotCard(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() => Container(
    height: 110,
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(24, 56, 24, 20),
    decoration: const BoxDecoration(color: RoadmapColors.primaryTeal),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Parent Dashboard",
          style: GoogleFonts.inter(
            fontSize: 13,
            color: const Color(0xFFD9EDEA)
          )
        ),
        const SizedBox(height: 4),
        Text("${data.childName}'s Progress",
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: RoadmapColors.surfaceWhite
          )
        ),
      ],
    ),
  );

  Widget _buildSummaryCard() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: RoadmapColors.surfaceWhite,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: RoadmapColors.borderLight),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Field of Interest: ${data.fieldOfInterest}",
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: RoadmapColors.textDark
          )
        ),
        const SizedBox(height: 8),
        Text(data.summaryText,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: RoadmapColors.textMuted,
            height: 1.5
          )
        ),
      ],
    ),
  );

  Widget _buildStatsCard() => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: RoadmapColors.surfaceWhite,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: RoadmapColors.borderLight),
    ),
    child: Column(
      children: [
        _buildStatRow("Roadmap progress", "${data.roadmapProgressPercent}%"),
        const SizedBox(height: 14),
        _buildStatRow("Quiz completed", data.quizCompleted ? "Yes" : "Not yet"),
        const SizedBox(height: 14),
        _buildStatRow("Next milestone", data.nextMilestoneLabel),
      ],
    ),
  );

  Widget _buildStatRow(String label, String value) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: GoogleFonts.inter(fontSize: 13, color: RoadmapColors.textMuted)),
      Text(value, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: RoadmapColors.textDark)),
    ],
  );

  Widget _buildChatbotCard(BuildContext context) => GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatbotScreen(isParentMode: true)));
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(color: RoadmapColors.lightTeal, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(color: RoadmapColors.primaryTeal, shape: BoxShape.circle),
            child: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Confused about entry tests? Ask our Guidance Chatbot — simple answers, no jargon",
              style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: RoadmapColors.textDark),
            ),
          ),
        ],
      ),
    ),
  );
}
