import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'constants.dart';

class Scholarship {
  final String name;
  final String provider;
  final String coverageLabel;
  final String eligibilityText;
  final String fullDescription;
  final String applyUrl;
  final List<String> matchedFields; // Can be filtered by field

  Scholarship({
    required this.name,
    required this.provider,
    required this.coverageLabel,
    required this.eligibilityText,
    required this.fullDescription,
    required this.applyUrl,
    required this.matchedFields,
  });
}

final List<Scholarship> allScholarships = [
  Scholarship(
    name: "HEC Need-Based Scholarship",
    provider: "Higher Education Commission",
    coverageLabel: "Up to 100% tuition",
    eligibilityText: "Family income under PKR 45,000/month",
    fullDescription: "A comprehensive scholarship program designed to support students from low-income families in pursuing higher education in public sector universities.",
    applyUrl: "https://hec.gov.pk",
    matchedFields: ["Pre-Engineering", "Pre-Medical", "ICS (Computer Science)", "Commerce", "Arts / Humanities"],
  ),
  Scholarship(
    name: "NUST Merit Scholarship",
    provider: "NUST",
    coverageLabel: "50-100% tuition",
    eligibilityText: "Top 5% in entry test + FSc marks",
    fullDescription: "Based on merit, awarded to top performing students in the entry test and FSc board exams.",
    applyUrl: "https://nust.edu.pk",
    matchedFields: ["Pre-Engineering", "ICS (Computer Science)"],
  ),
  Scholarship(
    name: "Ehsaas Undergraduate Program",
    provider: "Govt of Pakistan",
    coverageLabel: "Full tuition + stipend",
    eligibilityText: "Low-income households, all provinces",
    fullDescription: "The largest undergraduate scholarship program in Pakistan, covering tuition fees and providing a monthly stipend.",
    applyUrl: "https://ehsaas.nadra.gov.pk",
    matchedFields: ["Pre-Engineering", "Pre-Medical", "ICS (Computer Science)", "Commerce", "Arts / Humanities"],
  ),
];

class ScholarshipInfoScreen extends StatelessWidget {
  final String? filterField;

  const ScholarshipInfoScreen({super.key, this.filterField});

  @override
  Widget build(BuildContext context) {
    final filteredScholarships = filterField != null
        ? allScholarships.where((s) => s.matchedFields.contains(filterField)).toList()
        : allScholarships;

    return Scaffold(
      backgroundColor: RoadmapColors.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                itemCount: filteredScholarships.length,
                separatorBuilder: (ctx, index) => const SizedBox(height: 14),
                itemBuilder: (ctx, index) => _buildScholarshipCard(context, filteredScholarships[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() => Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(24, 56, 24, 16),
    decoration: const BoxDecoration(color: RoadmapColors.surfaceWhite),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Scholarships for You",
            style: GoogleFonts.inter(fontSize: 19, fontWeight: FontWeight.bold, color: RoadmapColors.textDark)),
        const SizedBox(height: 4),
        Text("Based on your city and budget",
            style: GoogleFonts.inter(fontSize: 12, color: RoadmapColors.textMuted)),
      ],
    ),
  );

  Widget _buildScholarshipCard(BuildContext context, Scholarship scholarship) => GestureDetector(
    onTap: () => _showDetailSheet(context, scholarship),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: RoadmapColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: RoadmapColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(scholarship.name, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: RoadmapColors.textDark)),
          const SizedBox(height: 4),
          Text(scholarship.provider, style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF999992))),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: RoadmapColors.lightTeal, borderRadius: BorderRadius.circular(8)),
            child: Text(scholarship.coverageLabel, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: RoadmapColors.primaryTeal)),
          ),
          const SizedBox(height: 8),
          Text(scholarship.eligibilityText, style: GoogleFonts.inter(fontSize: 12, color: RoadmapColors.textMuted), maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    ),
  );

  void _showDetailSheet(BuildContext context, Scholarship scholarship) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(scholarship.name, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text(scholarship.fullDescription, style: GoogleFonts.inter(fontSize: 14, color: RoadmapColors.textMuted)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: RoadmapColors.primaryTeal),
                onPressed: () async {
                  final Uri url = Uri.parse(scholarship.applyUrl);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
                child: Text("Apply Now", style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
