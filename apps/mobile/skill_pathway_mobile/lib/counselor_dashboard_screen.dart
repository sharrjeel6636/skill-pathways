import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/app_colors.dart';
import 'constants.dart';
import 'roadmap_screen.dart';

class CounselorProfile {
  final String name;
  final String institutionName;
  final List<String> linkedStudentIds;

  CounselorProfile({required this.name, required this.institutionName, required this.linkedStudentIds});
}

class CounselorNote {
  final String counselorId;
  final String text;
  final DateTime postedAt;
  final List<String> targetStudentIds;

  CounselorNote({required this.counselorId, required this.text, required this.postedAt, required this.targetStudentIds});
}

class CounselorDashboardScreen extends StatelessWidget {
  final CounselorProfile profile;

  const CounselorDashboardScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RoadmapColors.bgLight,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Your Students", style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: RoadmapColors.textDark)),
                  const SizedBox(height: 16),
                  _buildStudentCard("Sharjeel", "Class 10 · Pre-Engineering", 0.45, context),
                  _buildStudentCard("Ayesha", "Class 10 · Science", 0.60, context),
                  const SizedBox(height: 24),
                  Text("Post a Note", style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: RoadmapColors.textDark)),
                  const SizedBox(height: 16),
                  TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Share local guidance — e.g. 'Our school's ECAT prep classes start in March'",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      filled: true, fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    child: Container(
                      width: double.infinity, height: 48,
                      decoration: BoxDecoration(color: RoadmapColors.primaryTeal, borderRadius: BorderRadius.circular(14)),
                      child: Center(child: Text("Post to My Students", style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() => Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(24, 56, 24, 20),
    decoration: BoxDecoration(color: RoadmapColors.primaryTeal),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Counselor Dashboard", style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFFD9EDEA))),
        Text(profile.institutionName, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    ),
  );

  Widget _buildStudentCard(String name, String details, double progress, BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: RoadmapColors.borderLight)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: RoadmapColors.textDark)),
          Text(details, style: GoogleFonts.inter(fontSize: 12, color: RoadmapColors.textMuted)),
        ]),
        Text("${(progress * 100).toInt()}%", style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: RoadmapColors.primaryTeal)),
      ],
    ),
  );
}
