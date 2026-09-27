import 'package:flutter/material.dart';
import '../models/shared_models.dart';
import '../services/api_client.dart';
import 'dart:convert';

class CourseProvider extends ChangeNotifier {
  List<CourseListing> _courses = [];
  bool _isLoading = false;
  String? _error;

  List<CourseListing> get courses => _courses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchCourses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiClient.get('/learning-material');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _courses = data.map((item) {
          return CourseListing(
            platform: 'Online',
            title: item['title'] ?? '',
            level: 'Beginner',
            durationLabel: item['duration'] ?? '',
            isFree: true,
            tags: [item['pathway_tag'] ?? ''],
            detail: CourseDetail(
              id: item['id']?.toString() ?? '',
              title: item['title'] ?? '',
              platform: 'Online',
              description: '',
              learningPoints: [],
              externalUrl: item['content_url'] ?? '',
            ),
          );
        }).toList();
      } else {
        _error = 'Failed to load courses';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
