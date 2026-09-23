import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'constants.dart';
import 'models/shared_models.dart';
import 'providers/CertificationProvider.dart';

class CourseDetailScreen extends StatelessWidget {
  final CourseDetail course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RoadmapColors.surfaceWhite,
      body: Column(
        children: [
          // Hero Banner
          Container(
            height: 180,
            width: double.infinity,
            color: RoadmapColors.lightTeal,
            // Add Image.network here later:
            // child: course.imageUrl != null ? Image.network(course.imageUrl!, fit: BoxFit.cover) : null,
          ),
          // Scrollable Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course.platform, style: GoogleFonts.inter(fontSize: 12, color: RoadmapColors.primaryTeal)),
                  const SizedBox(height: 4),
                  Text(course.title, style: GoogleFonts.inter(fontSize: 21, fontWeight: FontWeight.bold, color: RoadmapColors.textDark)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildChip(course.level),
                      const SizedBox(width: 8),
                      _buildChip(course.durationLabel),
                      const SizedBox(width: 8),
                      _buildChip(course.isFree ? "Free" : "Paid"),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text("Description", style: GoogleFonts.inter(fontSize: 14, color: RoadmapColors.textMuted, height: 1.5)),
                  const SizedBox(height: 16),
                  Text("What you'll learn", style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: RoadmapColors.textDark)),
                  const SizedBox(height: 12),
                  ...course.learningPoints.map((point) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                    children: [
                    Container(width: 5, height: 5, decoration: BoxDecoration(color: RoadmapColors.primaryTeal, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(point, style: GoogleFonts.inter(fontSize: 12, color: RoadmapColors.textMuted))),
                    ],
                    ),
                    )),
                    ],
                    ),
                    ),
                    ),
                    // Pinned CTA
                    Container(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                    decoration: BoxDecoration(color: RoadmapColors.surfaceWhite),
                    child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: RoadmapColors.primaryTeal, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                onPressed: () async {
                  Provider.of<CertificationProvider>(context, listen: false).markInProgress(course.title);
                  
                  final Uri url = Uri.parse(course.externalUrl);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
                child: Text("Start Course", style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(color: const Color(0xFFF5F5F3), borderRadius: BorderRadius.circular(8)),
    child: Text(label, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: RoadmapColors.textMuted)),
  );
}
