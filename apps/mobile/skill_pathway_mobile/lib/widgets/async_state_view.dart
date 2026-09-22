import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

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
            color: AppColors.primary,
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
                const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                const SizedBox(height: 16),
                Text(errorMessage,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: onRetry,
                  child: Text("Try Again", style: AppTextStyles.button),
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
                    color: AppColors.background, // Should probably be a lighter variant
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.search_off, size: 32, color: AppColors.primary),
                ),
                const SizedBox(height: 16),
                Text(emptyMessage,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
        );
      case AsyncViewState.data:
        return child;
    }
  }
}
