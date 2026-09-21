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
