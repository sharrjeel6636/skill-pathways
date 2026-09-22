import 'package:flutter/material.dart';
import '../models/course_model.dart';

class CourseProvider extends ChangeNotifier {
  List<dynamic> _courses = []; // TODO: Migrate CourseListing logic here

  List<dynamic> get courses => _courses;

  void addCourse(dynamic course) {
    _courses.add(course);
    notifyListeners();
  }
  
  void updateCourses(List<dynamic> courses) {
    _courses = courses;
    notifyListeners();
  }
}
