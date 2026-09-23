import 'package:flutter/material.dart';
import 'theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'constants.dart';

class VocationalTrade {
  final String name;
  final String durationLabel;
  final String incomeRangeLabel;
  final String availabilityNote;

  VocationalTrade({
    required this.name,
    required this.durationLabel,
    required this.incomeRangeLabel,
    required this.availabilityNote,
  });
}

class TrainingInstitute {
  final String name;
  final String cityOrCoverage;
  final String feeLabel;
  final String durationLabel;

  TrainingInstitute({
    required this.name,
    required this.cityOrCoverage,
    required this.feeLabel,
    required this.durationLabel,
  });
}

class VocationalPathScreen extends StatelessWidget {
  const VocationalPathScreen({super.key});

  final List<String> trades = const [
    "Electrician", "Plumber", "HVAC Technician", "Automotive Mechanic",
    "Tailoring/Fashion Design", "IT Support Technician", "Beautician",
    "Welder", "Solar Panel Installer", "Mobile Repair Technician"
  ];

  final List<TrainingInstitute> institutes = const [
    TrainingInstitute(name: "TEVTA (Punjab)", cityOrCoverage: "Multiple cities", feeLabel: "Low-cost / subsidized", durationLabel: "6 months - 2 years"),
    TrainingInstitute(name: "NAVTTC", cityOrCoverage: "Nationwide", feeLabel: "Free/subsidized", durationLabel: "3 months - 1 year"),
    TrainingInstitute(name: "Local Private Institute", cityOrCoverage: "Your City", feeLabel: "Varies", durationLabel: "Varies"),
  ];

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
                  Text("Popular Trades", style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: RoadmapColors.textDark)),
                  const SizedBox(height: 16),
                  Wrap(spacing: 10, runSpacing: 10, children: trades.map(_buildTradeChip).toList()),
                  const SizedBox(height: 24),
                  Text("Training Institutes", style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: RoadmapColors.textDark)),
                  const SizedBox(height: 16),
                  ...institutes.map(_buildInstituteCard),
                  const SizedBox(height: 24),
                  _buildWhyConsiderCard(),
                  const SizedBox(height: 24),
                  _buildCTA(context),
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
    decoration: const BoxDecoration(color: RoadmapColors.primaryTeal),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Vocational & Technical Training", style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 4),
        Text("Skill-based careers, often faster and more affordable than university", style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFFD9EDEA))),
      ],
    ),
  );

  Widget _buildTradeChip(String trade) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: RoadmapColors.borderLight)),
    child: Text(trade, style: GoogleFonts.inter(fontSize: 13, color: RoadmapColors.textDark)),
  );

  Widget _buildInstituteCard(TrainingInstitute institute) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: RoadmapColors.borderLight)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(institute.name, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: RoadmapColors.textDark)),
        Text("${institute.cityOrCoverage} · ${institute.feeLabel} · ${institute.durationLabel}", style: GoogleFonts.inter(fontSize: 11, color: RoadmapColors.textMuted)),
      ],
    ),
  );

  Widget _buildWhyConsiderCard() => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(color: RoadmapColors.lightTeal, borderRadius: BorderRadius.circular(16)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBullet("Often costs far less than a 4-year degree"),
        _buildBullet("Many trades have strong, immediate local demand"),
        _buildBullet("You can start earning in months, not years"),
      ],
    ),
  );

  Widget _buildBullet(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        const Icon(Icons.circle, size: 8, color: RoadmapColors.primaryTeal),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: GoogleFonts.inter(fontSize: 12, color: RoadmapColors.textDark))),
      ],
    ),
  );

  Widget _buildCTA(BuildContext context) => GestureDetector(
    onTap: () => context.push('/roadmap'),
    child: Container(
      width: double.infinity, height: 52,
      decoration: BoxDecoration(color: RoadmapColors.primaryTeal, borderRadius: BorderRadius.circular(14)),
      child: Center(child: Text("See Trade Training Roadmap", style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white))),
    ),
  );
}
