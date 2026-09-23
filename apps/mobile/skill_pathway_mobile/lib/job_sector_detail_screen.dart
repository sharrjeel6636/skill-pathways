import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'models/shared_models.dart';

class JobSectorDetailScreen extends StatelessWidget {
  final JobListing job;

  const JobSectorDetailScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    Color headerColor;
    String sectorLabel;

    switch (job.sector) {
      case JobSector.private_:
        headerColor = RoadmapColors.primaryTeal;
        sectorLabel = "PRIVATE";
        break;
      case JobSector.govt:
        headerColor = const Color(0xFF8C59BF);
        sectorLabel = "GOVT";
        break;
      case JobSector.remote:
        headerColor = RoadmapColors.accentAmber;
        sectorLabel = "REMOTE";
        break;
      case JobSector.corporate:
        headerColor = RoadmapColors.primaryTeal;
        sectorLabel = "CORPORATE";
        break;
    }

    return Scaffold(
      backgroundColor: RoadmapColors.bgLight,
      body: Column(
        children: [
          _buildHeader(headerColor, sectorLabel),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(),
                  const SizedBox(height: 16),
                  Text("How to Prepare",
                      style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: RoadmapColors.textDark)),
                  const SizedBox(height: 16),
                  _buildPreparationSteps(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Color color, String label) => Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 56, 24, 20),
        decoration: BoxDecoration(color: color),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10)),
              child: Text(label,
                  style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
            const SizedBox(height: 8),
            Text(job.detail.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ],
        ),
      );

  Widget _buildInfoCard() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
            color: RoadmapColors.surfaceWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: RoadmapColors.borderLight)),
        child: Column(
          children: [
            _buildInfoRow("Entry path", job.detail.entryPath),
            const SizedBox(height: 14),
            _buildInfoRow("Required degree", job.detail.requiredDegree),
            const SizedBox(height: 14),
            _buildInfoRow("Starting salary", job.detail.startingSalary),
            const SizedBox(height: 14),
            _buildInfoRow("Job security", job.detail.jobSecurityLevel),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.push('/career-growth-roadmap'),
              style: ElevatedButton.styleFrom(backgroundColor: RoadmapColors.primaryTeal, foregroundColor: Colors.white),
              child: const Text("View Career Growth Roadmap →"),
            ),
          ],
        ),
      );

  Widget _buildInfoRow(String label, String value) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 13, color: RoadmapColors.textMuted)),
          Text(value,
              style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: RoadmapColors.textDark)),
        ],
      );

  Widget _buildPreparationSteps() => Column(
        children: job.detail.preparationSteps
            .map((step) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: RoadmapColors.lightTeal),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(step,
                            style: GoogleFonts.inter(
                                fontSize: 13, color: RoadmapColors.textDark)),
                      ),
                    ],
                  ),
                ))
            .toList(),
      );
}
