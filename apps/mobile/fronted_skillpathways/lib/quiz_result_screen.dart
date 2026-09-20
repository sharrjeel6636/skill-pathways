import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'quiz_model.dart';
import 'roadmap_screen.dart';
import 'field_selection_screen.dart';

class QuizResultScreen extends StatelessWidget {
  final QuizResult result;

  const QuizResultScreen({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF7),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopHeader(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  children: [
                    Expanded(flex: 4, child: _buildResultCard()),
                    const SizedBox(height: 16),
                    Expanded(flex: 3, child: _buildNextStepsSection()),
                    const SizedBox(height: 16),
                    Expanded(flex: 1, child: _buildCTASection(context)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader() => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
    decoration: const BoxDecoration(
      color: Color(0xFF0B766F),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(32),
        bottomRight: Radius.circular(32),
      ),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Assessment Complete!",
          style: GoogleFonts.inter(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          "We've analyzed your career inclinations",
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: const Color(0xFFD9EDEA),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );

  Widget _buildResultCard() {
    final int total = result.totalQuestions;
    final int scienceCount = result.scores["Science"] ?? 0;
    final int commerceCount = result.scores["Commerce"] ?? 0;
    final int artsCount = result.scores["Arts"] ?? 0;

    int sciencePct = (scienceCount / total * 100).round();
    int commercePct = (commerceCount / total * 100).round();
    int artsPct = 100 - sciencePct - commercePct;

    if (artsPct < 0) artsPct = 0;

    // To decide colors based on ranking
    List<MapEntry<String, int>> sortedScores = result.scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    Color getFieldColor(String field) {
      if (field == sortedScores[0].key) {
        return const Color(0xFF0B766F); // primary color
      } else if (field == sortedScores[1].key) {
        return const Color(0xFFF5A20B); // accentAmber
      } else {
        return const Color(0xFF7E8A87); // muted gray
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildBarRow("Science", sciencePct, getFieldColor("Science")),
          _buildBarRow("Commerce", commercePct, getFieldColor("Commerce")),
          _buildBarRow("Arts", artsPct, getFieldColor("Arts")),
        ],
      ),
    );
  }

  Widget _buildBarRow(String field, int percentage, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              field,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500, // Medium
                color: const Color(0xFF1E2022),
              ),
            ),
            Text(
              "$percentage%",
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600, // SemiBold
                color: const Color(0xFF1E2022),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 8,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFE5E7EB), // borderLight
            borderRadius: BorderRadius.circular(4), // radius 4
          ),
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: percentage / 100,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNextStepsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Recommended next steps",
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E2022),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildStepChip("Explore colleges"),
            const SizedBox(width: 8),
            _buildStepChip("Review subjects"),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildStepChip("Consult with counselor"),
          ],
        ),
      ],
    );
  }

  Widget _buildStepChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE9F5F3), // bg #E9F5F3
        borderRadius: BorderRadius.circular(14), // radius 14
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500, // Medium
          color: const Color(0xFF0B766F),
        ),
      ),
    );
  }

  Widget _buildCTASection(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FieldSelectionScreen(
                  recommendedField: result.topField,
                ),
              ),
            );
          },
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF0B766F),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0B766F).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: Text(
                "View My Full Roadmap",
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
