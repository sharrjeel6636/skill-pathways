import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'university_shortlist_screen.dart';
import 'models/shared_models.dart';

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
                    // Removed city, feePerSemester, meritPercent access as it's not in the new UniversityDetail class
                    const SizedBox(height: 24),
                    Text("Overview", style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: RoadmapColors.textDark)),
                    const SizedBox(height: 8),
                    Text(university.overview, style: GoogleFonts.inter(fontSize: 14, color: RoadmapColors.textMuted, height: 1.5)),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () => context.push('/scholarship-info'),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: RoadmapColors.lightTeal, borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          children: [
                            const Icon(Icons.school, color: RoadmapColors.primaryTeal),
                            const SizedBox(width: 12),
                            Expanded(child: Text("Scholarship Available: Yes — Need-based", style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: RoadmapColors.textDark))),
                            const Icon(Icons.chevron_right, color: RoadmapColors.textMuted),
                          ],
                        ),
                      ),
                    ),
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
