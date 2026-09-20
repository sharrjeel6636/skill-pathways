import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'shared_data.dart';

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
                  ...job.detail.preparationSteps.map((step) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Container(
                                width: 24,
                                height: 24,
                                decoration: const BoxDecoration(
                                    color: RoadmapColors.lightTeal, shape: BoxShape.circle)),
                            const SizedBox(width: 12),
                            Expanded(
                                child: Text(step,
                                    style: GoogleFonts.inter(
                                        fontSize: 13, color: RoadmapColors.textDark))),
                          ],
                        ),
                      )),
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
                  color: color == RoadmapColors.accentAmber ? const Color(0xFF1C1917) : RoadmapColors.accentAmber,
                  borderRadius: BorderRadius.circular(10)),
              child: Text(label,
                  style: GoogleFonts.inter(
                      fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            const SizedBox(height: 8),
            Text(job.title,
                style: GoogleFonts.inter(
                    fontSize: 19, fontWeight: FontWeight.bold, color: Colors.white),
                maxLines: 2),
          ],
        ),
      );

  Widget _buildInfoCard() => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: RoadmapColors.surfaceWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: RoadmapColors.borderLight),
        ),
        child: Column(
          children: [
            _buildInfoRow("Entry path", job.detail.entryPath),
            _buildInfoRow("Required degree", job.detail.requiredDegree),
            _buildInfoRow("Starting salary", job.detail.startingSalary),
            _buildInfoRow("Job security", job.detail.jobSecurityLevel),
          ],
        ),
      );

  Widget _buildInfoRow(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.inter(fontSize: 13, color: RoadmapColors.textMuted)),
            Text(value, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: RoadmapColors.textDark)),
          ],
        ),
      );
}
