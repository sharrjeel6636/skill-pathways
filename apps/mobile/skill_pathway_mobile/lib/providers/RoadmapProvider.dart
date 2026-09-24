import 'package:flutter/material.dart';
import '../models/shared_models.dart';

class RoadmapProvider extends ChangeNotifier {
  Map<String, List<CareerGrowthLevel>> _roleToGrowthMap = roleToGrowthMap;

  RoadmapProvider();

  Map<String, List<CareerGrowthLevel>> get roleToGrowthMap => _roleToGrowthMap;

  void updateGrowthMap(Map<String, List<CareerGrowthLevel>> newMap) {
    _roleToGrowthMap = newMap;
    notifyListeners();
  }
}


