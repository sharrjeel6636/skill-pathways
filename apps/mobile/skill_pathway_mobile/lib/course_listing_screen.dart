import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'theme/app_colors.dart';
import 'constants.dart';
import 'models/shared_models.dart';
import 'course_detail_screen.dart';
import 'widgets/async_state_view.dart';
import 'providers/CourseProvider.dart';

class CourseListingScreen extends StatefulWidget {
  const CourseListingScreen({super.key});

  @override
  State<CourseListingScreen> createState() => _CourseListingScreenState();
}

class _CourseListingScreenState extends State<CourseListingScreen> {
  String _selectedFilter = "All";
  AsyncViewState _state = AsyncViewState.data; // Use data directly from provider

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseProvider>(
      builder: (context, provider, child) {
        final allCourses = provider.courses;
        final filteredCourses = _selectedFilter == "All"
            ? allCourses
            : allCourses.where((c) {
                if (_selectedFilter == "Free") return c.isFree;
                if (_selectedFilter == "Beginner") return c.level == "Beginner";
                return c.tags.contains(_selectedFilter);
              }).toList();

        return Scaffold(
          backgroundColor: RoadmapColors.bgLight,
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: AsyncStateView(
                    state: filteredCourses.isEmpty ? AsyncViewState.empty : _state,
                    onRetry: () {},
                    emptyMessage: "No courses match your filter.",
                    errorMessage: "Failed to load courses.",
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                      itemCount: filteredCourses.length,
                      separatorBuilder: (ctx, index) => const SizedBox(height: 14),
                      itemBuilder: (ctx, index) => _buildCourseCard(context, filteredCourses[index]),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Courses & Certifications",
                style: GoogleFonts.inter(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: RoadmapColors.textDark)),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ["All", "Free", "Programming", "Business", "Beginner"]
                    .map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedFilter = filter),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? RoadmapColors.primaryTeal
                              : const Color(0xFFF5F5F3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(filter,
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : RoadmapColors.textMuted)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );

  Widget _buildCourseCard(BuildContext context, CourseListing course) =>
      GestureDetector(
        onTap: () {
          context.push('/course-detail', extra: course.detail);
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: RoadmapColors.surfaceWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: RoadmapColors.borderLight),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                    color: RoadmapColors.lightTeal,
                    borderRadius: BorderRadius.circular(12)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(course.platform.toUpperCase(),
                        style: GoogleFonts.inter(
                            fontSize: 11, color: RoadmapColors.primaryTeal)),
                    const SizedBox(height: 4),
                    Text(course.title,
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: RoadmapColors.textDark),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text("${course.level} · ${course.durationLabel}",
                        style: GoogleFonts.inter(
                            fontSize: 11, color: RoadmapColors.textMuted)),
                  ],
                ),
              ),
              if (course.isFree)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: RoadmapColors.accentAmber,
                      borderRadius: BorderRadius.circular(8)),
                  child: Text("FREE",
                      style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
            ],
          ),
        ),
      );
}
