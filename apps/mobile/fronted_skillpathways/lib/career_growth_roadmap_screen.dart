import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'shared_data.dart';

class CareerGrowthRoadmapScreen extends StatelessWidget {
  final String currentRole;

  const CareerGrowthRoadmapScreen({super.key, required this.currentRole});

  @override
  Widget build(BuildContext context) {
    final levels = roleToGrowthMap[currentRole] ?? [];

    return Scaffold(
      backgroundColor: RoadmapColors.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(levels),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                child: Column(
                  children: levels.asMap().entries.map((entry) {
                    final index = entry.key;
                    final level = entry.value;
                    return _buildTimelineRow(level, index == levels.length - 1);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(List<CareerGrowthLevel> levels) => Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 56, 24, 18),
        decoration: const BoxDecoration(color: RoadmapColors.surfaceWhite),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Career Growth Path",
                style: GoogleFonts.inter(
                    fontSize: 19, fontWeight: FontWeight.bold, color: RoadmapColors.textDark)),
            const SizedBox(height: 4),
            Text(levels.map((l) => l.title.split("/").first.trim()).join(" → "),
                style: GoogleFonts.inter(fontSize: 12, color: RoadmapColors.textMuted),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ],
        ),
      );

  Widget _buildTimelineRow(CareerGrowthLevel level, bool isLast) {
    Color bgColor;
    switch (level.status) {
      case GrowthLevelStatus.active:
        bgColor = RoadmapColors.primaryTeal;
        break;
      case GrowthLevelStatus.next:
        bgColor = RoadmapColors.accentAmber;
        break;
      case GrowthLevelStatus.locked:
        bgColor = RoadmapColors.lockedGray;
        break;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            ),
            if (!isLast)
              Container(width: 3, height: 48, color: RoadmapColors.borderLight),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(level.title,
                  style: GoogleFonts.inter(
                      fontSize: level.status == GrowthLevelStatus.locked ? 14 : 15,
                      fontWeight: level.status == GrowthLevelStatus.locked
                          ? FontWeight.w500
                          : FontWeight.w600,
                      color: level.status == GrowthLevelStatus.locked
                          ? RoadmapColors.textMuted
                          : RoadmapColors.textDark)),
              const SizedBox(height: 4),
              Text(level.subtitle,
                  style: GoogleFonts.inter(fontSize: 11, color: RoadmapColors.textMuted)),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }
}
