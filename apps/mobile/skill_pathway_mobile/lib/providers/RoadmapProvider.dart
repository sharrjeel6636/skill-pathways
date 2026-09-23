import 'package:flutter/material.dart';
import '../models/shared_models.dart';
import '../quiz_model.dart';

class RoadmapProvider extends ChangeNotifier {
  Map<String, List<CareerGrowthLevel>> _roleToGrowthMap = Map.from(roleToGrowthMap);
  List<RoadmapStage> _stages = []; // Assuming some default or mechanism to populate

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
