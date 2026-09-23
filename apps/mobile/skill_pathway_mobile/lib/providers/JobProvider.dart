import 'package:flutter/material.dart';
import '../models/shared_models.dart';

class JobProvider extends ChangeNotifier {
  late List<JobListing> _jobs;

  JobProvider() {
    _jobs = List.from(allJobs);
  }

  List<JobListing> get jobs => _jobs;
  List<JobListing> get allJobs => _jobs;

  void updateJobs(List<JobListing> jobs) {
    _jobs = jobs;
    notifyListeners();
  }
}
