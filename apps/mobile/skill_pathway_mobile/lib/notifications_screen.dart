import 'package:flutter/material.dart';
import 'theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'widgets/async_state_view.dart';

class ScheduledReminder {
  final String id;
  final String title;
  final DateTime eventDate;
  final DateTime createdAt;

  ScheduledReminder({
    required this.id,
    required this.title,
    required this.eventDate,
    required this.createdAt,
  });
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Demo data for now - will be driven by local storage
    final List<ScheduledReminder> reminders = [];

    return Scaffold(
      backgroundColor: RoadmapColors.bgLight,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: reminders.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                    itemCount: reminders.length,
                    separatorBuilder: (ctx, index) => const SizedBox(height: 12),
                    itemBuilder: (ctx, index) => _buildReminderRow(reminders[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() => Container(
        padding: const EdgeInsets.fromLTRB(24, 56, 24, 16),
        decoration: const BoxDecoration(color: RoadmapColors.surfaceWhite),
        width: double.infinity,
        child: Text("Reminders",
            style: GoogleFonts.inter(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: RoadmapColors.textDark)),
      );

  Widget _buildEmptyState() => Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.notifications_none, size: 48, color: RoadmapColors.textMuted),
              const SizedBox(height: 16),
              Text(
                  "No reminders set yet. Turn on the bell icon next to any test date or deadline to get reminded.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      fontSize: 14, color: RoadmapColors.textMuted)),
            ],
          ),
        ),
      );

  Widget _buildReminderRow(ScheduledReminder reminder) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: RoadmapColors.surfaceWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: RoadmapColors.borderLight),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(reminder.title,
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: RoadmapColors.textDark)),
                Text(reminder.eventDate.toString().substring(0, 10),
                    style: GoogleFonts.inter(
                        fontSize: 11, color: RoadmapColors.textMuted)),
              ],
            ),
            Text("Remove",
                style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: RoadmapColors.textMuted)),
          ],
        ),
      );
}
