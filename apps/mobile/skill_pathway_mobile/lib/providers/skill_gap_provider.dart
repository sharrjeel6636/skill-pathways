import 'package:flutter/material.dart';
import '../models/skill_gap_models.dart';
import '../models/shared_models.dart';
import '../providers/CertificationProvider.dart';
import '../providers/RoadmapProvider.dart';
import '../services/skill_requirement_service.dart';

class SkillGapProvider extends ChangeNotifier {
  final CertificationProvider _certificationProvider;
  final RoadmapProvider _roadmapProvider;
  final SkillRequirementService _skillRequirementService;

  bool _isLoading = false;
  List<GapAnalysisItem> _gaps = [];

  SkillGapProvider(
    this._certificationProvider,
    this._roadmapProvider,
    this._skillRequirementService,
  );

  bool get isLoading => _isLoading;
  List<GapAnalysisItem> get gaps => _gaps;

  Future<void> analyzeGaps(String targetRole) async {
    _isLoading = true;
    notifyListeners();

    final completedSkills = _certificationProvider.progress.entries
        .where((e) => e.value == CertStatus.completed)
        .map((e) => e.key)
        .toList();

    final stages = _roadmapProvider.stages;
    _gaps = stages.map((stage) {
      final required = _skillRequirementService.getRequiredSkillsForStage(stage.title);
      final completed = required.where((s) => completedSkills.contains(s)).toList();
      final missing = required.where((s) => !completedSkills.contains(s)).toList();

      return GapAnalysisItem(
        stageTitle: stage.title,
        completedSkills: completed,
        missingSkills: missing,
        recommendedCourses: missing,
      );
    }).toList();

    _isLoading = false;
    notifyListeners();
  }
}
