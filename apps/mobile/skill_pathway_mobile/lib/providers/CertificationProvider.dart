import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/shared_models.dart';

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

      _progress = {};
      for (final item in (response as List)) {
        final stepId = item['step_id'] as int;
        final status = item['status'] as String;
        // Map back to CertStatus
        final certStatus = status == 'mastered' ? CertStatus.completed : CertStatus.inProgress;
        _progress[stepId.toString()] = certStatus;
      }
    } catch (e) {
      debugPrint('Error fetching progress: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markInProgress(String courseId) async {
    _progress[courseId] = CertStatus.inProgress;
    await _updateSupabase(courseId, 'active');
    notifyListeners();
  }

  Future<void> markCompleted(String courseId) async {
    _progress[courseId] = CertStatus.completed;
    await _updateSupabase(courseId, 'mastered');
    notifyListeners();
  }

  Future<void> _updateSupabase(String courseId, String status) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      final stepId = int.tryParse(courseId);
      if (stepId == null) return;

      await _supabase.from('user_progress').upsert({
        'user_id': userId,
        'step_id': stepId,
        'status': status,
      });
    } catch (e) {
      debugPrint('Error updating progress: $e');
    }
  }

}
