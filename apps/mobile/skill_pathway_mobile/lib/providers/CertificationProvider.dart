import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/course_model.dart';

class CertificationProvider extends ChangeNotifier {
  Map<String, CertStatus> _progress = {};
  bool _isLoading = false;

  Map<String, CertStatus> get progress => _progress;
  bool get isLoading => _isLoading;

  final _supabase = Supabase.instance.client;

  Future<void> fetchProgress() async {
    _isLoading = true;
    notifyListeners();

    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      final response = await _supabase
          .from('user_progress')
          .select('step_id, status')
          .eq('user_id', userId);

      // This would need a mapping between step_id and course title
      // For now, keep as placeholder logic
      _progress = {}; 
    } catch (e) {
      debugPrint('Error fetching progress: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void markInProgress(String courseName) {
    _progress[courseName] = CertStatus.inProgress;
    // TODO: Update in Supabase
    notifyListeners();
  }
}
