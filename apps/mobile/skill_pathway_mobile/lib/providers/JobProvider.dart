import 'package:flutter/material.dart';
import '../shared_data.dart';

class JobProvider extends ChangeNotifier {
  List<JobListing> _jobs = List.from(allJobs);

  List<JobListing> get jobs => _jobs;

  void updateJobs(List<JobListing> jobs) {
    _jobs = jobs;
    notifyListeners();
  }
}
