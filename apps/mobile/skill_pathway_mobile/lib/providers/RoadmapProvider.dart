import 'package:flutter/material.dart';
import '../models/shared_models.dart';

class RoadmapProvider extends ChangeNotifier {
  Map<String, List<CareerGrowthLevel>> _roleToGrowthMap = const {};

  RoadmapProvider() {
    _roleToGrowthMap = Map<String, List<CareerGrowthLevel>>.from(roleToGrowthMap);
  }

  Map<String, List<CareerGrowthLevel>> get roleToGrowthMap => _roleToGrowthMap;

  // SkillGapProvider compatibility ke liye stages getter
  List<dynamic> get stages => _roleToGrowthMap.values.expand((element) => element).toList();

  void updateGrowthMap(Map<String, List<CareerGrowthLevel>> newMap) {
    _roleToGrowthMap = newMap;
    notifyListeners();
  }
}