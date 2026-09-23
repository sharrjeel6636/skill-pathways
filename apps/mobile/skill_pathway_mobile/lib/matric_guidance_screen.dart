import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/app_colors.dart';
import 'field_selection_screen.dart';
import 'vocational_path_screen.dart';

class MatricGuideEntry {
  final String groupName;
  final Color accentColor;
  final List<String> bulletPoints;
  final bool isVocational;

  MatricGuideEntry({
    required this.groupName,
    required this.accentColor,
    required this.bulletPoints,
    this.isVocational = false,
  });
}

class MatricGuidanceScreen extends StatelessWidget {
  const MatricGuidanceScreen({super.key});

  final List<MatricGuideEntry> entries = const [
    MatricGuideEntry(
      groupName: "If you choose Science",
      accentColor: RoadmapColors.primaryTeal,
      bulletPoints: [
        "Focus on Math, Physics, Chemistry, Biology",
        "Opens doors to Pre-Medical, Pre-Engineering, ICS"
      ],
    ),
    MatricGuideEntry(
      groupName: "If you choose Arts",
      accentColor: RoadmapColors.accentAmber,
      bulletPoints: [
        "Focus on English, Islamiat, Pak Studies + electives",
        "Opens doors to Humanities, Law, Media, Design"
      ],
    ),
    MatricGuideEntry(
      groupName: "If you choose Commerce",
      accentColor: Color(0xFF8C59BF), // purpleAccent
      bulletPoints: [
        "Focus on Accounting, Economics, Business Studies",
        "Opens doors to BBA, ACCA, Banking, Finance"
      ],
    ),
    MatricGuideEntry(
      groupName: "If you don't want to continue to Intermediate",
      accentColor: RoadmapColors.accentAmber,
      bulletPoints: [
        "Learn a skilled trade directly after Matric",
        "Many trades need only 6 months to 2 years of training"
      ],
      isVocational: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RoadmapColors.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                child: Column(
                  children: entries.map((entry) => _buildGuidanceCard(context, entry)).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() => Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(24, 56, 24, 18),
    decoration: const BoxDecoration(
      color: RoadmapColors.surfaceWhite,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Matric Guidance",
          style: GoogleFonts.inter(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: RoadmapColors.textDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Class 9-10 — build the right foundation",
          style: GoogleFonts.inter(
            fontSize: 12,
            color: RoadmapColors.textMuted,
          ),
        ),
      ],
    ),
  );

  Widget _buildGuidanceCard(BuildContext context, MatricGuideEntry entry) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: GestureDetector(
      onTap: () {
        if (entry.isVocational) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const VocationalPathScreen()));
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FieldSelectionScreen(recommendedField: entry.groupName.replaceAll("If you choose ", "")),
            ),
          );
        }
      },
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
            Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: entry.accentColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    entry.groupName,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: RoadmapColors.textDark,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...entry.bulletPoints.map((point) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: RoadmapColors.textMuted,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      point,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: RoadmapColors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    ),
  );
}
