import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'quiz_model.dart';
import 'models/shared_models.dart';
import 'university_detail_screen.dart';

class DegreeComparisonScreen extends StatelessWidget {
  final String confirmedField;

  const DegreeComparisonScreen({super.key, required this.confirmedField});

  @override
  Widget build(BuildContext context) {
    final degrees = fieldToDegreesMap[confirmedField] ?? [];
    final matchingUniversities = allUniversities.where((u) => u.matchedFields.contains(confirmedField)).toList();

    return Scaffold(
      backgroundColor: RoadmapColors.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(degrees),
            SizedBox(
              height: 280,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                scrollDirection: Axis.horizontal,
                itemCount: degrees.length,
                separatorBuilder: (ctx, index) => const SizedBox(width: 12),
                itemBuilder: (ctx, index) => _buildDegreeCard(degrees[index]),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 6, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Matching Universities",
                        style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: RoadmapColors.textDark)),
                    const SizedBox(height: 14),
                    ...matchingUniversities.map((uni) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildUniversityRow(context, uni),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(List<DegreeComparisonEntry> degrees) => Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 56, 24, 16),
        decoration: const BoxDecoration(color: RoadmapColors.surfaceWhite),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Compare Degrees",
                style: GoogleFonts.inter(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: RoadmapColors.textDark)),
            const SizedBox(height: 4),
            Text(degrees.map((d) => d.name).join(" vs "),
                style: GoogleFonts.inter(fontSize: 12, color: RoadmapColors.textMuted)),
          ],
        ),
      );

  Widget _buildDegreeCard(DegreeComparisonEntry degree) => Container(
        width: 210,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: degree.isRecommended ? RoadmapColors.lightTeal : RoadmapColors.surfaceWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: degree.isRecommended ? RoadmapColors.primaryTeal : RoadmapColors.borderLight,
            width: degree.isRecommended ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(degree.name,
                style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: RoadmapColors.textDark)),
            const SizedBox(height: 14),
            _buildMetricRow("Duration", "${degree.durationLabel}"),
            _buildMetricRow("Avg. salary (entry)", degree.salaryRange),
            _buildMetricRow("Job demand", degree.jobDemandLevel),
            _buildMetricRow("Focus", degree.focusDescription),
          ],
        ),
      );

  Widget _buildMetricRow(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF999992))),
            Text(value, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: RoadmapColors.textDark)),
          ],
        ),
      );

  Widget _buildUniversityRow(BuildContext context, UniversityListing uni) => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UniversityDetailScreen(university: uni.detail),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: RoadmapColors.surfaceWhite,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: RoadmapColors.borderLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${uni.name} — ${uni.city}",
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: RoadmapColors.textDark)),
              const SizedBox(height: 4),
              Text("${uni.city} · Fee: ${uni.feePerSemester}/sem · Merit: ${uni.meritPercent}%",
                  style: GoogleFonts.inter(fontSize: 11, color: RoadmapColors.textMuted)),
            ],
          ),
        ),
      );
}
