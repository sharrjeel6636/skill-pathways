import 'package:flutter/material.dart';

class UniversityDetail {
  final String name;
  final String city;
  final String overview;
  final String feePerSemester;
  final int meritPercent;
  final DateTime applicationDeadline;

  UniversityDetail({
    required this.name,
    required this.city,
    required this.overview,
    required this.feePerSemester,
    required this.meritPercent,
    required this.applicationDeadline,
  });
}

class UniversityListing {
  final String name;
  final String city;
  final String feePerSemester;
  final int meritPercent;
  final List<String> matchedFields;
  final UniversityDetail detail;

  UniversityListing({
    required this.name,
    required this.city,
    required this.feePerSemester,
    required this.meritPercent,
    required this.matchedFields,
    required this.detail,
  });
}

class DegreeComparisonEntry {
  final String name;
  final String durationLabel;
  final String salaryRange;
  final String jobDemandLevel;
  final String focusDescription;
  final bool isRecommended;

  DegreeComparisonEntry({
    required this.name,
    required this.durationLabel,
    required this.salaryRange,
    required this.jobDemandLevel,
    required this.focusDescription,
    this.isRecommended = false,
  });
}

enum CertStatus { completed, inProgress, notStarted }

class CertificationEntry {
  final String courseName;
  final CertStatus status;
  final String courseId;

  CertificationEntry({
    required this.courseName,
    required this.status,
    required this.courseId,
  });
}

enum PrepToolType { resumeTemplates, linkedinGuide, interviewQuestions, mockInterview }

class PrepTool {
  final String title;
  final String subtitle;
  final PrepToolType type;
  final IconData icon;

  PrepTool({
    required this.title,
    required this.subtitle,
    required this.type,
    required this.icon,
  });
}

enum JobSector { private_, govt, remote, corporate, trade }

class JobDetail {
  final String title;
  final String description;
  final String requirements;
  final String entryPath;
  final String requiredDegree;
  final String startingSalary;
  final String jobSecurityLevel;
  final List<String> preparationSteps;

  JobDetail({
    required this.title,
    required this.description,
    required this.requirements,
    required this.entryPath,
    required this.requiredDegree,
    required this.startingSalary,
    required this.jobSecurityLevel,
    required this.preparationSteps,
  });
}

class JobListing {
  final String title;
  final JobSector sector;
  final String city;
  final String salaryRange;
  final JobDetail detail;

  JobListing({
    required this.title,
    required this.sector,
    required this.city,
    required this.salaryRange,
    required this.detail,
  });
}

enum GrowthLevelStatus { active, next, locked }

class CareerGrowthLevel {
  final String title;
  final String subtitle;
  final GrowthLevelStatus status;

  CareerGrowthLevel({
    required this.title,
    required this.subtitle,
    required this.status,
  });
}
