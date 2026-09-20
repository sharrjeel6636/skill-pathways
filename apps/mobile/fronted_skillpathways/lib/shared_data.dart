import 'constants.dart';

class UniversityDetail {
  final String name;
  final String city;
  final String overview;
  final String feePerSemester;
  final int meritPercent;

  UniversityDetail({
    required this.name,
    required this.city,
    required this.overview,
    required this.feePerSemester,
    required this.meritPercent,
  });
}

class UniversityListing {
  final String name;
  final String city;
  final String feePerSemester;
  final int meritPercent;
  final List<String> matchedFields; // e.g. ["Pre-Engineering", "ICS"]
  final UniversityDetail detail; // full record for the detail screen

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

class CourseDetail {
  final String title;
  final String platform;
  final String description;
  final List<String> learningPoints;
  final String externalUrl;
  final String? imageUrl;

  CourseDetail({
    required this.title,
    required this.platform,
    required this.description,
    required this.learningPoints,
    required this.externalUrl,
    this.imageUrl,
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

final List<CourseListing> allCourses = [
  CourseListing(
    platform: "freeCodeCamp",
    title: "Python for Everybody",
    level: "Beginner",
    durationLabel: "4 weeks",
    isFree: true,
    tags: ["Programming"],
    detail: CourseDetail(
      title: "Python for Everybody",
      platform: "freeCodeCamp",
      description: "Learn Python from scratch.",
      learningPoints: ["Variables", "Loops", "Functions"],
      externalUrl: "https://www.freecodecamp.org",
    ),
  ),
  CourseListing(
    platform: "Coursera",
    title: "Intro to Data Science",
    level: "Intermediate",
    durationLabel: "6 weeks",
    isFree: false,
    tags: ["Programming"],
    detail: CourseDetail(
      title: "Intro to Data Science",
      platform: "Coursera",
      description: "Deep dive into Data Science.",
      learningPoints: ["Statistics", "Machine Learning", "Data Analysis"],
      externalUrl: "https://www.coursera.org",
    ),
  ),
  CourseListing(
    platform: "Local Bootcamp",
    title: "Web Development Basics",
    level: "Beginner",
    durationLabel: "8 weeks",
    isFree: true,
    tags: ["Programming"],
    detail: CourseDetail(
      title: "Web Development Basics",
      platform: "Local Bootcamp",
      description: "Master web fundamentals.",
      learningPoints: ["HTML", "CSS", "JS"],
      externalUrl: "https://example.com",
    ),
  ),
  CourseListing(
    platform: "LinkedIn Learning",
    title: "Business Communication",
    level: "All levels",
    durationLabel: "2 weeks",
    isFree: false,
    tags: ["Business"],
    detail: CourseDetail(
      title: "Business Communication",
      platform: "LinkedIn Learning",
      description: "Improve your professional skills.",
      learningPoints: ["Email writing", "Meetings", "Presentation"],
      externalUrl: "https://www.linkedin.com/learning",
    ),
  ),
];

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

class CertificationsTracker {
  static final Map<String, CertStatus> _progress = {
    "Python for Everybody": CertStatus.completed,
    "Web Development Basics": CertStatus.completed,
    "Intro to Data Science": CertStatus.inProgress,
    "Business Communication": CertStatus.notStarted,
    "Resume Writing Workshop": CertStatus.notStarted,
  };

  static Map<String, CertStatus> get progress => _progress;

  static void markInProgress(String courseName) {
    _progress[courseName] = CertStatus.inProgress;
  }
}
