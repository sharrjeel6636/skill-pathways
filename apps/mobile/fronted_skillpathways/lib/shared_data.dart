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

final List<UniversityListing> allUniversities = [
  UniversityListing(
    name: "NUST",
    city: "Islamabad",
    feePerSemester: "PKR 180k",
    meritPercent: 88,
    matchedFields: ["Pre-Engineering", "ICS (Computer Science)"],
    detail: UniversityDetail(
      name: "NUST",
      city: "Islamabad",
      overview: "Top-tier engineering university with a strong focus on research and innovation.",
      feePerSemester: "PKR 180k",
      meritPercent: 88,
    ),
  ),
  UniversityListing(
    name: "FAST-NUCES",
    city: "Karachi",
    feePerSemester: "PKR 150k",
    meritPercent: 82,
    matchedFields: ["Pre-Engineering", "ICS (Computer Science)"],
    detail: UniversityDetail(
      name: "FAST-NUCES",
      city: "Karachi",
      overview: "Renowned for its computing and software engineering programs.",
      feePerSemester: "PKR 150k",
      meritPercent: 82,
    ),
  ),
];
