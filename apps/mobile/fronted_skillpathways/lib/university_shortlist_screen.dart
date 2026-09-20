import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'quiz_model.dart';

class UniversityDetail {
  final String name;
  final String city;
  final String overview;
  final String feePerSemester;
  final int meritPercent;

  UniversityDetail({
    required this.name,
    required this.city,
    required this.overview,
    required this.feePerSemester,
    required this.meritPercent,
  });
}

class UniversityListing {
  final String name;
  final String city;
  final String feePerSemester;
  final int meritPercent;
  final List<String> matchedFields; // e.g. ["Pre-Engineering", "ICS"]
  final UniversityDetail detail; // full record for the detail screen

  UniversityListing({
    required this.name,
    required this.city,
    required this.feePerSemester,
    required this.meritPercent,
    required this.matchedFields,
    required this.detail,
  });
}

// Mock data
final List<UniversityListing> allUniversities = [
  UniversityListing(
    name: "NUST",
    city: "Islamabad",
    feePerSemester: "PKR 180k",
    meritPercent: 88,
    matchedFields: ["Pre-Engineering", "ICS (Computer Science)"],
    detail: UniversityDetail(
      name: "NUST",
      city: "Islamabad",
      overview: "Top-tier engineering university with a strong focus on research and innovation.",
      feePerSemester: "PKR 180k",
      meritPercent: 88,
    ),
  ),
  UniversityListing(
    name: "FAST-NUCES",
    city: "Karachi",
    feePerSemester: "PKR 150k",
    meritPercent: 82,
    matchedFields: ["Pre-Engineering", "ICS (Computer Science)"],
    detail: UniversityDetail(
      name: "FAST-NUCES",
      city: "Karachi",
      overview: "Renowned for its computing and software engineering programs.",
      feePerSemester: "PKR 150k",
      meritPercent: 82,
    ),
  ),
  UniversityListing(
    name: "Karachi University (Dept. CS)",
    city: "Karachi",
    feePerSemester: "PKR 20k",
    meritPercent: 70,
    matchedFields: ["Pre-Engineering", "ICS (Computer Science)"],
    detail: UniversityDetail(
      name: "Karachi University (Dept. CS)",
      city: "Karachi",
      overview: "Public sector university offering affordable quality education in CS.",
      feePerSemester: "PKR 20k",
      meritPercent: 70,
    ),
  ),
];

class UniversityShortlistScreen extends StatefulWidget {
  final String? initialFilterField;
  
  const UniversityShortlistScreen({super.key, this.initialFilterField});

  @override
  State<UniversityShortlistScreen> createState() => _UniversityShortlistScreenState();
}

class _UniversityShortlistScreenState extends State<UniversityShortlistScreen> {
  String _selectedFilter = "All";

  @override
  void initState() {
    super.initState();
    if (widget.initialFilterField != null) {
      _selectedFilter = widget.initialFilterField!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _selectedFilter == "All" 
      ? allUniversities 
      : allUniversities.where((u) => u.matchedFields.contains(_selectedFilter)).toList();

    return Scaffold(
      backgroundColor: RoadmapColors.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                itemCount: filteredList.length,
                separatorBuilder: (ctx, index) => const SizedBox(height: 12),
                itemBuilder: (ctx, index) => _buildUniversityCard(filteredList[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() => Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(24, 56, 24, 16),
    decoration: const BoxDecoration(color: RoadmapColors.surfaceWhite),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Matching Universities",
          style: GoogleFonts.inter(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: RoadmapColors.textDark,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ["All", "Pre-Engineering", "ICS (Computer Science)", "City ▾", "Fee ▾", "Merit ▾"].map((filter) {
              final isSelected = _selectedFilter == filter;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
                    if (!filter.contains("▾")) {
                      setState(() => _selectedFilter = filter);
                    } else {
                      // Bottom sheet filter logic would go here
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$filter filter not yet implemented")));
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? RoadmapColors.primaryTeal : const Color(0xFFF5F5F3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      filter,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white : RoadmapColors.textMuted,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    ),
  );

  Widget _buildUniversityCard(UniversityListing uni) => GestureDetector(
    onTap: () {
      // Navigate to UniversityDetailScreen
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("UniversityDetailScreen for ${uni.name} not built yet")));
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: RoadmapColors.surfaceWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: RoadmapColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${uni.name} — ${uni.city}",
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: RoadmapColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "${uni.city} · Fee: ${uni.feePerSemester}/sem · Merit: ${uni.meritPercent}%",
            style: GoogleFonts.inter(
              fontSize: 11,
              color: RoadmapColors.textMuted,
            ),
          ),
        ],
      ),
    ),
  );
}
