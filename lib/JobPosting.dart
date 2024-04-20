class JobPosting {
  final String jobTitle;
  final String jobDescription;
  final String companyInfo;
  final String location;
  final String imageUrl;
  final String employmentType;
  final List<String> requiredQualifications;
  final List<String> preferredQualifications;
  final String salaryRange;
  final List<String> benefits;
  final DateTime deadline;

  JobPosting({
    required this.jobTitle,
    required this.jobDescription,
    required this.companyInfo,
    required this.location,
    required this.imageUrl,
    required this.employmentType,
    required this.requiredQualifications,
    required this.preferredQualifications,
    required this.salaryRange,
    required this.benefits,
    required this.deadline,
  });
}
