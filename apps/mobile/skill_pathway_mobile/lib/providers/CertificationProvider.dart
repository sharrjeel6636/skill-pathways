import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../shared_data.dart';

class CertificationProvider extends ChangeNotifier {
  Map<String, CertStatus> _progress = Map.from(CertificationsTracker.progress);

  Map<String, CertStatus> get progress => _progress;

  void markInProgress(String courseName) {
    _progress[courseName] = CertStatus.inProgress;
    CertificationsTracker.markInProgress(courseName); // Keep in sync
    notifyListeners();
  }
}
