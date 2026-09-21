import 'package:flutter/material.dart';
import '../shared_data.dart';

class CourseProvider extends ChangeNotifier {
  List<CourseListing> _courses = List.from(allCourses);

  List<CourseListing> get courses => _courses;

  void addCourse(CourseListing course) {
    _courses.add(course);
    notifyListeners();
  }
  
  void updateCourses(List<CourseListing> courses) {
    _courses = courses;
    notifyListeners();
  }
}
