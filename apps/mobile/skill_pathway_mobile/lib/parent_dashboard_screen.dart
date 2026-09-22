import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'theme/app_colors.dart';
import 'theme/app_spacing.dart';
import 'theme/app_text_styles.dart';
import 'widgets/async_state_view.dart';
import 'services/api_client.dart';

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
      summaryText: "Progress analysis text goes here.",
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text("Parent Dashboard", style: AppTextStyles.bodyMedium.copyWith(color: AppColors.surface)),
      ),
      body: AsyncStateView(
        state: _state,
        onRetry: _fetchData,
        child: _data == null ? const SizedBox() : _buildContent(),
      ),
    );
  }

  Widget _buildContent() => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.p24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${_data!.childName}'s Progress", style: AppTextStyles.titleLarge),
        const SizedBox(height: AppSpacing.p24),
        _buildSummaryCard(),
        const SizedBox(height: AppSpacing.p16),
        _buildStatsCard(),
        const SizedBox(height: AppSpacing.p24),
        Text("Ask a Question", style: AppTextStyles.titleSmall),
        const SizedBox(height: AppSpacing.p12),
        _buildChatbotCard(context),
      ],
    ),
  );

  Widget _buildSummaryCard() => Container(
    padding: const EdgeInsets.all(AppSpacing.p24),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.r16),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Field of Interest: ${_data!.fieldOfInterest}", style: AppTextStyles.titleSmall),
        const SizedBox(height: AppSpacing.p8),
        Text(_data!.summaryText, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
      ],
    ),
  );

  Widget _buildStatsCard() => Container(
    padding: const EdgeInsets.all(AppSpacing.p24),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.r16),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      children: [
        _buildStatRow("Roadmap progress", "${_data!.roadmapProgressPercent}%"),
        const SizedBox(height: AppSpacing.p16),
        _buildStatRow("Quiz completed", _data!.quizCompleted ? "Yes" : "Not yet"),
        const SizedBox(height: AppSpacing.p16),
        _buildStatRow("Next milestone", _data!.nextMilestoneLabel),
      ],
    ),
  );

  Widget _buildStatRow(String label, String value) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
      Text(value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
    ],
  );

  Widget _buildChatbotCard(BuildContext context) => GestureDetector(
    onTap: () => context.push('/chatbot', extra: {'isParentMode': true}),
    child: Container(
      padding: const EdgeInsets.all(AppSpacing.p16),
      decoration: BoxDecoration(color: AppColors.lightTeal, borderRadius: BorderRadius.circular(AppSpacing.r16)),
      child: Row(
        children: [
          const CircleAvatar(backgroundColor: AppColors.primary, child: Icon(Icons.chat_bubble_outline, color: AppColors.surface, size: 20)),
          const SizedBox(width: AppSpacing.p16),
          Expanded(
            child: Text(
              "Ask our Guidance Chatbot for simple answers",
              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ],
      ),
    ),
  );
}
