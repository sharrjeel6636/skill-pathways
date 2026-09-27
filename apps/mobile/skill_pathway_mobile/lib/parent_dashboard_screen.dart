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
      childName: json['child_name'] ?? 'Ayesha',
      fieldOfInterest: json['pathway_title'] ?? 'Pre-Engineering',
      summaryText: json['summary_text'] ??
          "Based on aptitude quiz results, your child shows strong interest in Math, Physics and problem-solving. Recommended path: FSc Pre-Engineering leading to Engineering or CS degrees.",
      roadmapProgressPercent: (json['progress_percent'] ?? 35).toInt(),
      quizCompleted: (json['steps_done'] ?? 1) > 0,
      nextMilestoneLabel: json['next_step'] ?? 'Entry test prep',
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
  bool _isLinked = false;
  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _redeemCode() async {
    try {
      final response = await ApiClient.post('/parent-link/redeem', {'code': _codeController.text});
      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Account linked!")));
          _fetchData();
        }
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid or expired code")));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error linking account")));
    }
  }

  Future<void> _fetchData() async {
    setState(() => _state = AsyncViewState.loading);
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId != null) {
        final response = await ApiClient.get('/dashboard/$userId');
        if (response.statusCode == 200) {
          final decoded = jsonDecode(response.body);
          // Simple check if real data is returned (not demo)
          if (decoded['child_name'] != "Ayesha" || decoded['pathway_title'] != "Pre-Engineering") {
            setState(() {
              _data = ParentDashboardData.fromJson(decoded);
              _isLinked = true;
              _state = AsyncViewState.data;
            });
            return;
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching parent dashboard: $e");
    }

    setState(() {
      _isLinked = false;
      _state = AsyncViewState.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text("Parent Dashboard", style: AppTextStyles.bodyMedium.copyWith(color: AppColors.surface, fontWeight: FontWeight.w600)),
      ),
      body: AsyncStateView(
        state: _state,
        onRetry: _fetchData,
        child: _isLinked ? _buildContent() : _buildLinkUI(),
      ),
    );
  }

  Widget _buildLinkUI() => Padding(
    padding: const EdgeInsets.all(AppSpacing.p24),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.link, size: 64, color: AppColors.primary),
        const SizedBox(height: AppSpacing.p24),
        Text("Link your child's account", style: AppTextStyles.titleLarge),
        const SizedBox(height: AppSpacing.p16),
        TextField(
          controller: _codeController,
          decoration: const InputDecoration(hintText: "Enter 6-digit invite code", border: OutlineInputBorder()),
        ),
        const SizedBox(height: AppSpacing.p16),
        ElevatedButton(onPressed: _redeemCode, child: const Text("Link Account")),
      ],
    ),
  );

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
        Text(
          "Field of Interest: ${_data!.fieldOfInterest}",
          style: AppTextStyles.titleSmall,
        ),
        const SizedBox(height: AppSpacing.p8),
        Text(
          _data!.summaryText,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
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
    onTap: () {
      final studentName = _data?.childName ?? 'your child';
      final field = _data?.fieldOfInterest ?? 'Interest';
      context.push('/chatbot?isParentMode=true&student_name=$studentName&field=$field');
    },
    child: Container(
      padding: const EdgeInsets.all(AppSpacing.p16),
      decoration: BoxDecoration(
        color: AppColors.lightTeal,
        borderRadius: BorderRadius.circular(AppSpacing.r16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: AppColors.primary,
            child: Icon(Icons.chat_bubble_outline, color: AppColors.surface, size: 20),
          ),
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
