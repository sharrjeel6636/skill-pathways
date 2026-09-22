import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/app_colors.dart';
import 'theme/app_spacing.dart';
import 'theme/app_text_styles.dart';
import 'quiz_model.dart';
import 'matric_guidance_screen.dart';
import 'widgets/async_state_view.dart';

class RoadmapScreen extends StatefulWidget {
  const RoadmapScreen({super.key});

  @override
  State<RoadmapScreen> createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends State<RoadmapScreen> {
  AsyncViewState _state = AsyncViewState.loading;
  List<RoadmapStage> _stages = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _state = AsyncViewState.loading);
    try {
      // Simulate fetch
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _stages = [
          RoadmapStage(title: "Matric (9th-10th)", subtitle: "Aptitude quiz completed", status: StageStatus.done),
          RoadmapStage(title: "Intermediate", subtitle: "FSc Pre-Engineering in progress", status: StageStatus.active),
          RoadmapStage(title: "University/Degree Selection", subtitle: "Locked until Inter results", status: StageStatus.locked),
          RoadmapStage(title: "University Life & Skills", subtitle: "Certifications & internships", status: StageStatus.locked),
          RoadmapStage(title: "Internship & Job Prep", subtitle: "Resume, interviews", status: StageStatus.locked),
          RoadmapStage(title: "Job & Career Growth", subtitle: "Long-term path", status: StageStatus.locked),
        ];
        _state = _stages.isEmpty ? AsyncViewState.empty : AsyncViewState.data;
      });
    } catch (e) {
      print(e);
      setState(() => _state = AsyncViewState.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: AsyncStateView(
                state: _state,
                onRetry: _fetchData,
                emptyMessage: "No roadmap stages found.",
                errorMessage: "Couldn't load your roadmap.",
                child: ListView.separated(
                  padding: AppSpacing.horizontalP16.copyWith(top: AppSpacing.p24, bottom: AppSpacing.p24),
                  itemCount: _stages.length,
                  separatorBuilder: (ctx, index) => const SizedBox(height: 0),
                  itemBuilder: (ctx, index) => _buildStageNode(ctx, _stages[index], index == _stages.length - 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() => Container(
    height: 110,
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(AppSpacing.p24, AppSpacing.p32, AppSpacing.p24, AppSpacing.p16),
    color: AppColors.surface,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Your Full Roadmap",
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.p4),
        Text(
          "Matric to Career — track every stage",
          style: GoogleFonts.inter(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    ),
  );

  Widget _buildStageNode(BuildContext context, RoadmapStage stage, bool isLast) => GestureDetector(
    onTap: () {
      if (stage.status != StageStatus.locked) {
        if (stage.title.contains("Matric")) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MatricGuidanceScreen()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Complete previous stages first")),
        );
      }
    },
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            _buildBadge(stage.status),
            if (!isLast)
              Container(
                width: 3,
                height: 48,
                color: stage.status == StageStatus.done ? AppColors.primary : AppColors.border,
              ),
          ],
        ),
        const SizedBox(width: AppSpacing.p16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stage.title,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: stage.status == StageStatus.locked ? FontWeight.w500 : FontWeight.w600,
                  color: stage.status == StageStatus.locked ? AppColors.textSecondary : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.p4),
              Text(
                stage.subtitle,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.p24), // Bottom padding for rhythm
            ],
          ),
        ),
      ],
    ),
  );

  Widget _buildBadge(StageStatus status) {
    Color bgColor;
    IconData? icon;

    switch (status) {
      case StageStatus.done:
        bgColor = AppColors.primary;
        icon = Icons.check;
        break;
      case StageStatus.active:
        bgColor = AppColors.accent;
        icon = null; // empty circle
        break;
      case StageStatus.locked:
        bgColor = AppColors.lockedGray;
        icon = Icons.lock_outline;
        break;
    }

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: icon != null
          ? Icon(icon, size: 16, color: AppColors.surface)
          : null,
    );
  }
}
