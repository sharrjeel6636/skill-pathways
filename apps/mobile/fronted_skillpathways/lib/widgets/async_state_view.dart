import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';

enum AsyncViewState { loading, error, empty, data }

class AsyncStateView extends StatelessWidget {
  final AsyncViewState state;
  final String errorMessage;
  final String emptyMessage;
  final VoidCallback onRetry;
  final Widget child;

  const AsyncStateView({
    super.key,
    required this.state,
    this.errorMessage = "Something went wrong. Please try again.",
    this.emptyMessage = "No items found.",
    required this.onRetry,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case AsyncViewState.loading:
        return const Center(
          child: CircularProgressIndicator(
            color: RoadmapColors.primaryTeal,
            strokeWidth: 3,
          ),
        );
      case AsyncViewState.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: RoadmapColors.errorRed),
                const SizedBox(height: 16),
                Text(errorMessage,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(fontSize: 14, color: RoadmapColors.textDark)),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: RoadmapColors.primaryTeal,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(150, 44),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text("Try Again", style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        );
      case AsyncViewState.empty:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: RoadmapColors.lightTeal,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.search_off, size: 32, color: RoadmapColors.primaryTeal),
                ),
                const SizedBox(height: 16),
                Text(emptyMessage,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(fontSize: 14, color: RoadmapColors.textMuted)),
              ],
            ),
          ),
        );
      case AsyncViewState.data:
        return child;
    }
  }
}
