import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'chatbot_screen.dart';
import 'widgets/async_state_view.dart';
import 'services/api_client.dart';
import 'constants.dart';

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

  factory ParentDashboardData.fromJson(Map<String, dynamic> json) {
    return ParentDashboardData(
      childName: "Child",
      fieldOfInterest: json['pathway_title'] ?? 'N/A',
      summaryText: "Progress analysis",
      roadmapProgressPercent: (json['progress_percent'] ?? 0).toInt(),
      quizCompleted: (json['steps_done'] ?? 0) > 0,
      nextMilestoneLabel: json['next_step'] ?? 'N/A',
    );
  }
}

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  AsyncViewState _state = AsyncViewState.loading;
  ParentDashboardData? _data;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _state = AsyncViewState.loading);
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw Exception("User not logged in");
      final response = await ApiClient.get('/dashboard/$userId');
      if (response.statusCode == 200) {
        setState(() {
          _data = ParentDashboardData.fromJson(jsonDecode(response.body));
          _state = AsyncViewState.data;
        });
      } else {
        setState(() => _state = AsyncViewState.error);
      }
    } catch (e) {
      setState(() => _state = AsyncViewState.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RoadmapColors.bgLight,
      body: AsyncStateView(
        state: _state,
        onRetry: _fetchData,
        child: _data == null ? const SizedBox() : _buildContent(),
      ),
    );
  }

  Widget _buildContent() => Column(
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
  );

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
        Text("${_data!.childName}'s Progress",
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
        Text("Field of Interest: ${_data!.fieldOfInterest}",
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: RoadmapColors.textDark
          )
        ),
        const SizedBox(height: 8),
        Text(_data!.summaryText,
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
        _buildStatRow("Roadmap progress", "${_data!.roadmapProgressPercent}%"),
        const SizedBox(height: 14),
        _buildStatRow("Quiz completed", _data!.quizCompleted ? "Yes" : "Not yet"),
        const SizedBox(height: 14),
        _buildStatRow("Next milestone", _data!.nextMilestoneLabel),
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
