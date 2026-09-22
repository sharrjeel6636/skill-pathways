import 'package:flutter/material.dart';
import '../models/course_model.dart';

class CertificationProvider extends ChangeNotifier {
  // TODO: Migrate CertStatus and CertificationsTracker logic here
  Map<String, dynamic> _progress = {}; 

  Map<String, dynamic> get progress => _progress;

  void markInProgress(String courseName) {
    // Logic needs to be updated once shared_data is removed
    notifyListeners();
  }
}
