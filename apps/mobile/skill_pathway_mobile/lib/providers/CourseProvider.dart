import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/shared_models.dart';

class CourseProvider extends ChangeNotifier {
  List<CourseListing> _courses = [];
  bool _isLoading = false;
  String? _error;

  List<CourseListing> get courses => _courses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final _supabase = Supabase.instance.client;

  Future<void> fetchCourses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _supabase.from('learning_materials').select('*');
      
      // Map Supabase data to CourseListing model
      _courses = (response as List).map((item) {
        return CourseListing(
          platform: 'Unknown', // Not in DB yet
          title: item['title'] ?? '',
          level: 'Beginner', // Not in DB yet
          durationLabel: item['duration'] ?? '',
          isFree: true, // Not in DB yet
          tags: [item['pathway_tag'] ?? ''],
          detail: CourseDetail(
            id: item['id']?.toString() ?? '',
            title: item['title'] ?? '',
            platform: 'Unknown',
            description: '', // Not in DB yet
            learningPoints: [], // Not in DB yet
            externalUrl: item['content_url'] ?? '',
          ),
        );
      }).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
