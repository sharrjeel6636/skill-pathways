import 'package:flutter/material.dart';
import '../models/shared_models.dart';
import '../quiz_model.dart';
import '../roadmap_model.dart';

class RoadmapProvider extends ChangeNotifier {
  late Map<String, List<CareerGrowthLevel>> _roleToGrowthMap;
  List<RoadmapStage> _stages = [];

  RoadmapProvider() {
    _roleToGrowthMap = Map.from(roleToGrowthMap);
  }

  Map<String, List<CareerGrowthLevel>> get roleToGrowthMap => _roleToGrowthMap;
  List<RoadmapStage> get stages => _stages;

  void updateRoleGrowth(String role, List<CareerGrowthLevel> levels) {
    _roleToGrowthMap[role] = levels;
    notifyListeners();
  }

  void updateStages(List<RoadmapStage> stages) {
    _stages = stages;
    notifyListeners();
  }
}
