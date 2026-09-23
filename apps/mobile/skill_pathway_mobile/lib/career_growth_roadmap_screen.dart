import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'theme/app_colors.dart';
import 'constants.dart';
import 'models/shared_models.dart';
import 'providers/RoadmapProvider.dart';

class CareerGrowthRoadmapScreen extends StatelessWidget {
  final String role;
  
  const CareerGrowthRoadmapScreen({super.key, this.role = 'student'});

  @override
  Widget build(BuildContext context) {
    return Consumer<RoadmapProvider>(
      builder: (context, provider, child) {
        final levels = provider.roleToGrowthMap[role] ?? [];
        
        // Header subtitle
        String subtitle = "";
        if (levels.isNotEmpty) {
          subtitle = levels.map((l) => l.title).join(" → ");
        }

        return Scaffold(
          backgroundColor: RoadmapColors.bgLight,
          body: Column(
            children: [
              _buildHeader(subtitle),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                  itemCount: levels.length,
                  separatorBuilder: (ctx, index) => const SizedBox(height: 0),
                  itemBuilder: (ctx, index) => _buildTimelineRow(
                      levels[index], index == levels.length - 1),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(String subtitle) => Container(
        padding: const EdgeInsets.fromLTRB(24, 56, 24, 18),
        decoration: BoxDecoration(color: RoadmapColors.surfaceWhite),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Career Growth Path",
                style: GoogleFonts.inter(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: RoadmapColors.textDark)),
            const SizedBox(height: 4),
            Text(subtitle,
                style: GoogleFonts.inter(
                    fontSize: 12, color: RoadmapColors.textMuted)),
          ],
        ),
      );

  Widget _buildTimelineRow(CareerGrowthLevel level, bool isLast) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              _buildBadge(level.status),
              if (!isLast)
                Container(
                  width: 3,
                  height: 48,
                  color: RoadmapColors.borderLight,
                ),
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
                        fontWeight: level.status == GrowthLevelStatus.locked ? FontWeight.w500 : FontWeight.w600,
                        color: level.status == GrowthLevelStatus.locked ? RoadmapColors.textMuted : RoadmapColors.textDark)),
                const SizedBox(height: 4),
                Text(level.subtitle,
                    style: GoogleFonts.inter(
                        fontSize: 11, color: RoadmapColors.textMuted)),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      );

  Widget _buildBadge(GrowthLevelStatus status) {
    Color bgColor;

    switch (status) {
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

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
    );
  }
}
