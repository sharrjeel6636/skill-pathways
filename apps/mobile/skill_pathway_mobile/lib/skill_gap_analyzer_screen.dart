import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'theme/app_colors.dart';
import 'widgets/async_state_view.dart';
import 'services/api_client.dart';
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';

class SkillGapAnalyzerScreen extends StatefulWidget {
  final String? targetRole;
  const SkillGapAnalyzerScreen({super.key, this.targetRole});

  @override
  State<SkillGapAnalyzerScreen> createState() => _SkillGapAnalyzerScreenState();
}

class _SkillGapAnalyzerScreenState extends State<SkillGapAnalyzerScreen> {
  AsyncViewState _state = AsyncViewState.data;
  String? _selectedRole;
  Map<String, dynamic>? _results;

  @override
  void initState() {
    super.initState();
    if (widget.targetRole != null) {
      _selectedRole = widget.targetRole;
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
      backgroundColor: RoadmapColors.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _state == AsyncViewState.loading
                  ? const Center(child: CircularProgressIndicator())
                  : _results == null
                      ? Center(child: Text("Select a role and analyze", style: GoogleFonts.inter(color: RoadmapColors.textMuted)))
                      : _buildResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: RoadmapColors.surfaceWhite),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedRole,
              hint: const Text("Select Role"),
              items: ['Software Engineer', 'Data Scientist', 'Electrical Engineer', 'Doctor', 'Accountant', 'Graphic Designer']
                  .map((role) => DropdownMenuItem(value: role, child: Text(role)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedRole = val),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _analyze, child: const Text("Analyze Gap")),
          ],
        ),
      );

  Widget _buildResults() => ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text("Have Skills:", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
          ...(_results!['have_skills'] as List).map((s) => ListTile(leading: Icon(Icons.check_circle, color: Colors.green), title: Text(s))),
          const SizedBox(height: 16),
          Text("Missing Skills:", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
          ...(_results!['missing_skills'] as List).map((s) => ListTile(leading: Icon(Icons.warning, color: Colors.amber), title: Text(s))),
        ],
      );
}
