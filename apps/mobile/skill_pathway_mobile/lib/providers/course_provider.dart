import 'package:flutter/material.dart';
import '../models/shared_models.dart';

class CourseProvider extends ChangeNotifier {
  List<CourseListing> _allCourses = allCourses;
  List<CourseListing> get allCourses => _allCourses;

  void updateCourses(List<CourseListing> newCourses) {
    _allCourses = newCourses;
    notifyListeners();
  }
}
