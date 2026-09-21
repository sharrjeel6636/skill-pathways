import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'shared_data.dart';
import 'job_sector_detail_screen.dart';
import 'widgets/async_state_view.dart';

class CareerExplorerScreen extends StatefulWidget {
  const CareerExplorerScreen({super.key});

  @override
  State<CareerExplorerScreen> createState() => _CareerExplorerScreenState();
}

class _CareerExplorerScreenState extends State<CareerExplorerScreen> {
  String _selectedSector = "All";
  AsyncViewState _state = AsyncViewState.loading;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _state = AsyncViewState.loading);
    // Simulate API fetch
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _state = AsyncViewState.data);
  }

  @override
  Widget build(BuildContext context) {
    final filteredJobs = _selectedSector == "All"
        ? allJobs
        : allJobs.where((j) {
            if (_selectedSector == "Private") return j.sector == JobSector.private_;
            if (_selectedSector == "Govt") return j.sector == JobSector.govt;
            if (_selectedSector == "Remote") return j.sector == JobSector.remote;
            if (_selectedSector == "Corporate") return j.sector == JobSector.corporate;
            if (_selectedSector == "Trade/Skilled") return j.sector == JobSector.trade;
            return true;
          }).toList();

    return Scaffold(
      backgroundColor: RoadmapColors.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: AsyncStateView(
                state: filteredJobs.isEmpty ? AsyncViewState.empty : _state,
                onRetry: _fetchData,
                emptyMessage: "No jobs match your filter. Try clearing filters.",
                errorMessage: "Failed to load jobs.",
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                  itemCount: filteredJobs.length,
                  separatorBuilder: (ctx, index) => const SizedBox(height: 14),
                  itemBuilder: (ctx, index) => _buildJobCard(context, filteredJobs[index]),
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
            Text("Career Explorer",
                style: GoogleFonts.inter(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: RoadmapColors.textDark)),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(color: const Color(0xFFF5F5F3), borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  const Icon(Icons.search, color: RoadmapColors.textMuted, size: 20),
                  const SizedBox(width: 8),
                  Text("Search jobs, sectors...",
                      style: GoogleFonts.inter(fontSize: 13, color: RoadmapColors.textMuted)),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ["All", "Private", "Govt", "Remote", "Corporate", "Trade/Skilled"].map((sector) {
                  final isSelected = _selectedSector == sector;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedSector = sector),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? RoadmapColors.primaryTeal : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: RoadmapColors.borderLight),
                        ),
                        child: Text(sector,
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isSelected ? Colors.white : RoadmapColors.textDark)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );

  Widget _buildJobCard(BuildContext context, JobListing job) {
    Color sectorColor;
    String sectorLabel;

    switch (job.sector) {
      case JobSector.private_:
        sectorColor = RoadmapColors.primaryTeal;
        sectorLabel = "Private";
        break;
      case JobSector.govt:
        sectorColor = const Color(0xFF8C59BF);
        sectorLabel = "Govt";
        break;
      case JobSector.remote:
        sectorColor = RoadmapColors.accentAmber;
        sectorLabel = "Remote";
        break;
      case JobSector.corporate:
        sectorColor = RoadmapColors.primaryTeal;
        sectorLabel = "Corporate";
        break;
      case JobSector.trade:
        sectorColor = RoadmapColors.accentAmber;
        sectorLabel = "Trade/Skilled";
        break;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => JobSectorDetailScreen(job: job)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
            color: RoadmapColors.surfaceWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: RoadmapColors.borderLight)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(job.title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: RoadmapColors.textDark))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: sectorColor, borderRadius: BorderRadius.circular(10)),
                  child: Text(sectorLabel, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text("${job.city} · ${job.salaryRange}",
                style: GoogleFonts.inter(fontSize: 12, color: RoadmapColors.textMuted)),
          ],
        ),
      ),
    );
  }
}
