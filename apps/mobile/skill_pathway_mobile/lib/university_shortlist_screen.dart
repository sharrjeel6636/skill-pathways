import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'quiz_model.dart';
import 'university_detail_screen.dart';
import 'models/shared_models.dart';
import 'widgets/async_state_view.dart';

class UniversityShortlistScreen extends StatefulWidget {
  final String? initialFilterField;
  
  const UniversityShortlistScreen({super.key, this.initialFilterField});

  @override
  State<UniversityShortlistScreen> createState() => _UniversityShortlistScreenState();
}

class _UniversityShortlistScreenState extends State<UniversityShortlistScreen> {
  String _selectedFilter = "All";
  AsyncViewState _state = AsyncViewState.loading;

  @override
  void initState() {
    super.initState();
    if (widget.initialFilterField != null) {
      _selectedFilter = widget.initialFilterField!;
    }
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _state = AsyncViewState.loading);
    // Simulate API fetch
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _state = AsyncViewState.data);
  }

  void _showFilterSheet(String filterType) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Filter by $filterType", style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
            // Add filtering options here
          ],
        ),
      ),
    );
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
              child: AsyncStateView(
                state: filteredList.isEmpty ? AsyncViewState.empty : _state,
                onRetry: _fetchData,
                emptyMessage: "No universities match your filter.",
                errorMessage: "Failed to load universities.",
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                  itemCount: filteredList.length,
                  separatorBuilder: (ctx, index) => const SizedBox(height: 12),
                  itemBuilder: (ctx, index) => _buildUniversityCard(filteredList[index]),
                ),
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
            children: ["All", "City ▾", "Fee ▾", "Merit ▾"].map((filter) {
              final isSelected = _selectedFilter == filter;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
                    if (filter == "All") {
                      setState(() => _selectedFilter = "All");
                    } else if (filter.contains("▾")) {
                      _showFilterSheet(filter.replaceAll(" ▾", ""));
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UniversityDetailScreen(university: uni.detail),
        ),
      );
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
