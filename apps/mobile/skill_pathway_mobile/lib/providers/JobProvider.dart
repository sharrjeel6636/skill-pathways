import 'package:flutter/material.dart';
import '../models/shared_models.dart';

class JobProvider extends ChangeNotifier {
  List<JobListing> _jobs = const [];

  JobProvider() {
    _jobs = List<JobListing>.from(allJobs);
  }

  List<JobListing> get jobs => _jobs;
  List<JobListing> get allJobs => _jobs;

  void updateJobs(List<JobListing> newJobs) {
    _jobs = newJobs;
    notifyListeners();
  }
}