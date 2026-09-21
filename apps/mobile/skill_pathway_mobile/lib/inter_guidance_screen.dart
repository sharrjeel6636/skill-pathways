import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'quiz_model.dart';
import 'field_selection_screen.dart';
import 'university_shortlist_screen.dart';
import 'widgets/reminder_toggle.dart';

class EntryTest {
  final String name;
  final String description;
  final String dateLabel;
  final DateTime eventDate;

  EntryTest({
    required this.name,
    required this.description,
    required this.dateLabel,
    required this.eventDate,
  });
}

final Map<String, List<EntryTest>> fieldToTestsMap = {
  "Pre-Engineering": [
    EntryTest(name: "ECAT", description: "Engineering College Admission Test for UETs", dateLabel: "June 15, 2027", eventDate: DateTime(2027, 6, 15)),
    EntryTest(name: "NUST NET", description: "NUST Entry Test for engineering programs", dateLabel: "May 10, 2027", eventDate: DateTime(2027, 5, 10)),
  ],
  "ICS (Computer Science)": [
    EntryTest(name: "ECAT", description: "Engineering College Admission Test for UETs", dateLabel: "June 15, 2027", eventDate: DateTime(2027, 6, 15)),
    EntryTest(name: "NUST NET", description: "NUST Entry Test for computing programs", dateLabel: "May 10, 2027", eventDate: DateTime(2027, 5, 10)),
  ],
  "Pre-Medical": [
    EntryTest(name: "MDCAT", description: "Medical and Dental College Admission Test", dateLabel: "July 20, 2027", eventDate: DateTime(2027, 7, 20)),
  ],
};

class InterGuidanceScreen extends StatelessWidget {
  const InterGuidanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String confirmedField = QuizState.fieldOfInterest ?? "Unknown Field";
    final List<EntryTest>? tests = fieldToTestsMap[confirmedField];

    return Scaffold(
      backgroundColor: RoadmapColors.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(confirmedField),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Entry Tests for You",
                        style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: RoadmapColors.textDark)),
                    const SizedBox(height: 12),
                    if (tests != null && tests.isNotEmpty)
                      ...tests.map((test) => _buildTestCard(test))
                    else
                      _buildNoTestCard(),
                    const SizedBox(height: 24),
                    Text("University Shortlist Preview",
                        style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: RoadmapColors.textDark)),
                    const SizedBox(height: 12),
                    _buildUniversityBanner(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String field) => Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 56, 24, 18),
        decoration: const BoxDecoration(color: RoadmapColors.surfaceWhite),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Intermediate Guidance",
                style: GoogleFonts.inter(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: RoadmapColors.textDark)),
            const SizedBox(height: 4),
            Text("$field · Entry test prep",
                style: GoogleFonts.inter(fontSize: 12, color: RoadmapColors.textMuted)),
          ],
        ),
      );

  Widget _buildTestCard(EntryTest test) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
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
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                    color: RoadmapColors.lightTeal,
                    borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.school_outlined, color: RoadmapColors.primaryTeal),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(test.name,
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: RoadmapColors.textDark)),
                    Text(test.description,
                        style: GoogleFonts.inter(
                            fontSize: 11, color: RoadmapColors.textMuted),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(test.dateLabel,
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: RoadmapColors.primaryTeal)),
                  ReminderToggle(
                    notificationId: test.name,
                    title: "${test.name} test in 7 days",
                    eventDate: test.eventDate,
                    reminderOffsets: const [Duration(days: 7), Duration(days: 1)],
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _buildNoTestCard() => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: RoadmapColors.surfaceWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: RoadmapColors.borderLight),
        ),
        child: Text(
          "No standardized entry test — merit is based on Intermediate marks",
          style: GoogleFonts.inter(fontSize: 12, color: RoadmapColors.textMuted),
        ),
      );

  Widget _buildUniversityBanner(BuildContext context) => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UniversityShortlistScreen(initialFilterField: QuizState.fieldOfInterest),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: RoadmapColors.accentAmber,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("View matching universities",
                  style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: RoadmapColors.textDark)),
              const Text("→",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: RoadmapColors.textDark)),
            ],
          ),
        ),
      );
}
