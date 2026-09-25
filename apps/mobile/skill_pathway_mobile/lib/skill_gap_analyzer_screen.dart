import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'theme/app_colors.dart';
import 'theme/app_spacing.dart';
import 'theme/app_text_styles.dart';
import 'widgets/async_state_view.dart';
import 'services/api_client.dart';

class SkillGapAnalyzerScreen extends StatefulWidget {
  final String? targetRole;
  const SkillGapAnalyzerScreen({super.key, this.targetRole});

  @override
  State<SkillGapAnalyzerScreen> createState() => _SkillGapAnalyzerScreenState();
}

class _SkillGapAnalyzerScreenState extends State<SkillGapAnalyzerScreen> {
  AsyncViewState _state = AsyncViewState.empty;
  String? _selectedRole;
  Map<String, dynamic>? _results;

  @override
  void initState() {
    super.initState();
    if (widget.targetRole != null) {
      _selectedRole = widget.targetRole;
      _analyze();
    }
  }

  Future<void> _analyze() async {
    if (_selectedRole == null) return;
    setState(() => _state = AsyncViewState.loading);
    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;
      final response = await ApiClient.get('/skill-gap-analysis/$userId?target_role=$_selectedRole');
      if (response.statusCode == 200) {
        setState(() {
          _results = jsonDecode(response.body);
          _state = AsyncViewState.data;
        });
      } else {
        setState(() => _state = AsyncViewState.error);
      }
    } catch (e) {
      setState(() => _state = AsyncViewState.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Skill Gap Analyzer")),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: AsyncStateView(
                state: _state,
                onRetry: _analyze,
                emptyMessage: "Select a role above to analyze your skill gaps.",
                child: _buildResults(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() => Container(
        padding: const EdgeInsets.all(AppSpacing.p24),
        color: AppColors.surface,
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: const InputDecoration(labelText: "Target Role", border: OutlineInputBorder()),
              items: ['Software Engineer', 'Data Scientist', 'Electrical Engineer', 'Doctor', 'Accountant', 'Graphic Designer']
                  .map((role) => DropdownMenuItem(value: role, child: Text(role)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedRole = val),
            ),
            const SizedBox(height: AppSpacing.p16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: _analyze, child: const Text("Analyze Gap")),
            ),
          ],
        ),
      );

  Widget _buildResults() {
    if (_results == null) return const SizedBox.shrink();
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.p24),
      children: [
        Text("Results for: ${_results!['target_role']}", style: AppTextStyles.titleMedium),
        const SizedBox(height: AppSpacing.p16),
        Text("Have Skills:", style: AppTextStyles.labelLarge),
        ...(_results!['have_skills'] as List).map((s) => ListTile(leading: const Icon(Icons.check_circle, color: AppColors.success), title: Text(s))),
        const SizedBox(height: AppSpacing.p16),
        Text("Skill Gaps:", style: AppTextStyles.labelLarge),
        ...(_results!['missing_skills'] as List).map((s) => ListTile(leading: const Icon(Icons.warning_amber_rounded, color: AppColors.error), title: Text(s))),
      ],
    );
  }
}
