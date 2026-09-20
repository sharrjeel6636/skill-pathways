import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'shared_data.dart';

class JobSectorDetailScreen extends StatelessWidget {
  final JobListing job;

  const JobSectorDetailScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RoadmapColors.surfaceWhite,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(job.title, style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: RoadmapColors.textDark)),
                    const SizedBox(height: 8),
                    Text("${job.city} · Salary: ${job.salaryRange}", style: GoogleFonts.inter(fontSize: 14, color: RoadmapColors.textMuted)),
                    const SizedBox(height: 24),
                    Text("Description", style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: RoadmapColors.textDark)),
                    const SizedBox(height: 8),
                    Text(job.detail.description, style: GoogleFonts.inter(fontSize: 14, color: RoadmapColors.textMuted, height: 1.5)),
                    const SizedBox(height: 16),
                    Text("Requirements", style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: RoadmapColors.textDark)),
                    const SizedBox(height: 8),
                    Text(job.detail.requirements, style: GoogleFonts.inter(fontSize: 14, color: RoadmapColors.textMuted, height: 1.5)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(16, 16, 24, 16),
    color: RoadmapColors.surfaceWhite,
    child: Row(
      children: [
        IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new)),
        Text("Job Details", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: RoadmapColors.textDark)),
      ],
    ),
  );
}
