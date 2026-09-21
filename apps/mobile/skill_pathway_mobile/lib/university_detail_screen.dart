import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'university_shortlist_screen.dart';

class UniversityDetailScreen extends StatelessWidget {
  final UniversityDetail university;

  const UniversityDetailScreen({super.key, required this.university});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RoadmapColors.bgLight,
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
                    Text(university.name, style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: RoadmapColors.textDark)),
                    const SizedBox(height: 8),
                    Text("${university.city} · Fee: ${university.feePerSemester}/sem · Merit: ${university.meritPercent}%",
                      style: GoogleFonts.inter(fontSize: 14, color: RoadmapColors.textMuted)),
                    const SizedBox(height: 24),
                    Text("Overview", style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: RoadmapColors.textDark)),
                    const SizedBox(height: 8),
                    Text(university.overview, style: GoogleFonts.inter(fontSize: 14, color: RoadmapColors.textMuted, height: 1.5)),
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
        Text("University Details", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: RoadmapColors.textDark)),
      ],
    ),
  );
}
