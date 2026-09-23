import 'package:flutter/material.dart';

// --- University Models ---
class UniversityDetail {
  final String id;
  final String name;
  final String overview;
  final List<String> matchedFields;
  final String city;
  final String feePerSemester;
  final int meritPercent;
  const UniversityDetail({
    required this.id,
    required this.name,
    required this.overview,
    this.matchedFields = const [],
    required this.city,
    required this.feePerSemester,
    required this.meritPercent,
  });
}

typedef UniversityListing = UniversityDetail;

const List<UniversityDetail> allUniversities = [
  UniversityDetail(
    id: 'nust',
    name: 'National University of Sciences & Technology (NUST)',
    overview: 'Premier science & technology institution offering world-class engineering and computing degrees.',
    matchedFields: ['Engineering', 'Computer Science'],
    city: 'Islamabad',
    feePerSemester: 'PKR 150k',
    meritPercent: 85,
  ),
  UniversityDetail(
    id: 'fast',
    name: 'FAST-NUCES',
    overview: 'Known for excellence in computer science and software engineering programs.',
    matchedFields: ['Computer Science', 'Software Engineering'],
    city: 'Lahore',
    feePerSemester: 'PKR 180k',
    meritPercent: 80,
  ),
];

// --- Degree Comparison Models ---
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

final Map<String, List<DegreeComparisonEntry>> fieldToDegreesMap = {
  "Pre-Engineering": [
    DegreeComparisonEntry(name: "BSCS", durationLabel: "4 years", salaryRange: "PKR 70k-120k", jobDemandLevel: "Very High", focusDescription: "Algorithms, software theory", isRecommended: true),
    DegreeComparisonEntry(name: "Software Eng", durationLabel: "4 years", salaryRange: "PKR 65k-110k", jobDemandLevel: "High", focusDescription: "System design, engineering process"),
    DegreeComparisonEntry(name: "Data Science", durationLabel: "4 years", salaryRange: "PKR 75k-130k", jobDemandLevel: "Growing fast", focusDescription: "Statistics, ML, analytics"),
  ],
  "ICS (Computer Science)": [
    DegreeComparisonEntry(name: "BSCS", durationLabel: "4 years", salaryRange: "PKR 70k-120k", jobDemandLevel: "Very High", focusDescription: "Algorithms, software theory", isRecommended: true),
    DegreeComparisonEntry(name: "Software Eng", durationLabel: "4 years", salaryRange: "PKR 65k-110k", jobDemandLevel: "High", focusDescription: "System design, engineering process"),
  ],
  "Pre-Medical": [
    DegreeComparisonEntry(name: "MBBS", durationLabel: "5 years", salaryRange: "PKR 50k-90k", jobDemandLevel: "Stable", focusDescription: "Clinical medicine, patient care", isRecommended: true),
    DegreeComparisonEntry(name: "Pharm-D", durationLabel: "5 years", salaryRange: "PKR 40k-80k", jobDemandLevel: "Growing", focusDescription: "Pharmacology, drug research"),
  ],
};

// --- Course Models ---
class CourseDetail {
  final String id;
  final String title;
  final String platform;
  final String level;
  final String durationLabel;
  final bool isFree;
  final String description;
  final List<String> learningPoints;
  final String externalUrl;
  const CourseDetail({
    required this.id,
    required this.title,
    required this.platform,
    this.level = 'Beginner',
    this.durationLabel = '4 Weeks',
    this.isFree = true,
    this.description = '',
    this.learningPoints = const [],
    this.externalUrl = '',
  });
}

class CourseListing {
  final String platform;
  final String title;
  final String level;
  final String durationLabel;
  final bool isFree;
  final List<String> tags; // e.g. ["Programming"], used for filter matching
  final CourseDetail detail;

  CourseListing({
    required this.platform,
    required this.title,
    required this.level,
    required this.durationLabel,
    required this.isFree,
    required this.tags,
    required this.detail,
  });
}

// --- Certification Models ---
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

// --- Prep Tool Models ---
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

class MatricGuideEntry {
  final String title;
  final String desc;
  const MatricGuideEntry({required this.title, required this.desc});
}

class TrainingInstitute {
  final String name;
  final String cityOrCoverage;
  final String feeLabel;
  final String durationLabel;
  const TrainingInstitute({required this.name, required this.cityOrCoverage, required this.feeLabel, required this.durationLabel});
}

// --- Job Models ---
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

final List<JobListing> allJobs = [
  JobListing(
    title: "Software Engineer",
    sector: JobSector.private_,
    city: "Karachi",
    salaryRange: "PKR 80k-150k",
    detail: JobDetail(
      title: "Software Engineer",
      description: "Develop scalable software solutions.",
      requirements: "2+ years experience",
      entryPath: "Direct application",
      requiredDegree: "BS Computer Science",
      startingSalary: "PKR 80k-150k",
      jobSecurityLevel: "High",
      preparationSteps: ["Build a strong portfolio", "Master data structures", "Prepare for coding interviews"],
    ),
  ),
  JobListing(
    title: "Assistant Director (BS-17)",
    sector: JobSector.govt,
    city: "Lahore",
    salaryRange: "PKR 60k-90k",
    detail: JobDetail(
      title: "Assistant Director",
      description: "Manage administrative operations.",
      requirements: "Masters degree",
      entryPath: "PPSC Exam",
      requiredDegree: "Masters in any discipline",
      startingSalary: "PKR 60k-90k",
      jobSecurityLevel: "Very High",
      preparationSteps: ["Complete your Bachelor's degree (16 years)", "Apply for CSS or PPSC when eligible", "Prepare with past papers & current affairs"],
    ),
  ),
  JobListing(
    title: "Licensed Electrician",
    sector: JobSector.trade,
    city: "Karachi",
    salaryRange: "PKR 40k-70k",
    detail: JobDetail(
      title: "Licensed Electrician",
      description: "Install and maintain electrical systems.",
      requirements: "Trade certification",
      entryPath: "Vocational Training",
      requiredDegree: "Matric + Trade Cert",
      startingSalary: "PKR 40k-70k",
      jobSecurityLevel: "High",
      preparationSteps: ["Complete Matric", "Enroll in a trade school", "Get licensed"],
    ),
  ),
];

// --- Career Growth Models ---
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

enum StageStatus { done, active, locked }

class RoadmapStage {
  final String title;
  final String subtitle;
  final StageStatus status;

  RoadmapStage({
    required this.title,
    required this.subtitle,
    required this.status,
  });
}

final Map<String, List<CareerGrowthLevel>> roleToGrowthMap = {
  "Software Engineer": [
    CareerGrowthLevel(title: "Software Engineer", subtitle: "You are here · 0-2 yrs", status: GrowthLevelStatus.active),
    CareerGrowthLevel(title: "Senior Software Engineer", subtitle: "Skill: System design, mentoring", status: GrowthLevelStatus.next),
    CareerGrowthLevel(title: "Tech Lead / Engineering Manager", subtitle: "Skill: Leadership, architecture", status: GrowthLevelStatus.locked),
    CareerGrowthLevel(title: "Switch path: Product / Freelance", subtitle: "Alternative growth options", status: GrowthLevelStatus.locked),
  ],
};
