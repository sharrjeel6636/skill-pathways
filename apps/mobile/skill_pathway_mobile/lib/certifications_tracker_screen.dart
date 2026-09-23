import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'models/shared_models.dart';
import 'course_detail_screen.dart';
import 'course_listing_screen.dart';
import 'widgets/async_state_view.dart';
import 'providers/CertificationProvider.dart';
import 'providers/CourseProvider.dart';

class CertificationsTrackerScreen extends StatefulWidget {
  const CertificationsTrackerScreen({super.key});

  @override
  State<CertificationsTrackerScreen> createState() => _CertificationsTrackerScreenState();
}

class _CertificationsTrackerScreenState extends State<CertificationsTrackerScreen> {
  // We'll assume the provider is initialized with data
  final AsyncViewState _state = AsyncViewState.data; 

  @override
  Widget build(BuildContext context) {
    return Consumer2<CertificationProvider, CourseProvider>(
      builder: (context, certProvider, courseProvider, child) {
        final progress = certProvider.progress;
        final allCourses = courseProvider.courses;
        
        final completedCount = progress.values.where((s) => s == CertStatus.completed).length;
        final totalCount = progress.length;
        final progressPercentage = totalCount > 0 ? completedCount / totalCount : 0.0;

        return Scaffold(
          backgroundColor: RoadmapColors.bgLight,
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: AsyncStateView(
                    state: _state,
                    onRetry: () {}, // Not needed as provider data is synchronous for now
                    emptyMessage: "You haven't started any courses yet.",
                    errorMessage: "Failed to load certifications.",
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                      child: Column(
                        children: [
                          _buildSummaryCard(completedCount, totalCount, progressPercentage),
                          const SizedBox(height: 16),
                          ...progress.entries.map((entry) => _buildCertificationRow(context, entry.key, entry.value, allCourses)).toList(),
                          const SizedBox(height: 16),
                          if (totalCount == 0)
                            ElevatedButton(
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CourseListingScreen())),
                              child: const Text("Browse Courses"),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() => Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 56, 24, 16),
        decoration: const BoxDecoration(color: RoadmapColors.surfaceWhite),
        child: Text("My Certifications",
            style: GoogleFonts.inter(
                fontSize: 19, fontWeight: FontWeight.bold, color: RoadmapColors.textDark)),
      );

  Widget _buildSummaryCard(int completed, int total, double percentage) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: RoadmapColors.primaryTeal,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("$completed of $total certifications completed",
                style: GoogleFonts.inter(
                    fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
            const SizedBox(height: 10),
            Container(
              height: 8,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(4)),
              child: FractionallySizedBox(
                widthFactor: percentage,
                child: Container(
                  decoration: BoxDecoration(
                      color: RoadmapColors.accentAmber,
                      borderRadius: BorderRadius.circular(4)),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildCertificationRow(BuildContext context, String courseName, CertStatus status, List<CourseListing> allCourses) {
    final isCompleted = status == CertStatus.completed;
    final isInProgress = status == CertStatus.inProgress;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {
          if (!isCompleted) {
            final course = allCourses.firstWhere((c) => c.title == courseName);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CourseDetailScreen(course: course.detail)),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: RoadmapColors.surfaceWhite,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: RoadmapColors.borderLight),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                    color: isCompleted ? RoadmapColors.primaryTeal : const Color(0xFFEBEBE9),
                    shape: BoxShape.circle),
                child: isCompleted ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(courseName, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: RoadmapColors.textDark))),
              Text(
                isCompleted ? "Completed" : (isInProgress ? "In Progress" : "Not started"),
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isCompleted ? RoadmapColors.primaryTeal : (isInProgress ? RoadmapColors.textMuted : const Color(0xFFB3B3AC)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
