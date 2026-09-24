import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/skill_gap_provider.dart';
import '../models/skill_gap_models.dart';

class SkillGapAnalyzerScreen extends StatelessWidget {
  final String targetRole;

  const SkillGapAnalyzerScreen({super.key, required this.targetRole});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Skill Gap Analysis: $targetRole")),
      body: Consumer<SkillGapProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.gaps.isEmpty) {
            return const Center(child: Text("No gaps found."));
          }
          return ListView.builder(
            itemCount: provider.gaps.length,
            itemBuilder: (context, index) {
              final gap = provider.gaps[index];
              return ExpansionTile(
                title: Text(gap.stageTitle),
                subtitle: Text("Completed: ${gap.completedSkills.length} | Missing: ${gap.missingSkills.length}"),
                children: [
                  ListTile(title: Text("Missing Skills: ${gap.missingSkills.join(', ')}")),
                  ListTile(title: Text("Recommended Courses: ${gap.recommendedCourses.join(', ')}")),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
