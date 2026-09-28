import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'theme/app_colors.dart';
import 'widgets/async_state_view.dart';
import 'services/api_client.dart';

class CounselorProfile {
  final String name;
  final String institutionName;
  final List<String> linkedStudentIds;

  CounselorProfile({
    required this.name,
    required this.institutionName,
    required this.linkedStudentIds,
  });
}

class StudentSummary {
  final String id;
  final String name;
  final String email;
  final String pathwayTitle;
  final double progressPercent;
  final int stepsDone;
  final int totalSteps;
  final String status;

  StudentSummary({
    required this.id,
    required this.name,
    required this.email,
    required this.pathwayTitle,
    required this.progressPercent,
    required this.stepsDone,
    required this.totalSteps,
    required this.status,
  });

  factory StudentSummary.fromJson(Map<String, dynamic> json) {
    return StudentSummary(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Student',
      email: json['email'] ?? '',
      pathwayTitle: json['pathway_title'] ?? 'General Track',
      progressPercent: (json['progress_percent'] ?? 0.0).toDouble(),
      stepsDone: json['steps_done'] ?? 0,
      totalSteps: json['total_steps'] ?? 5,
      status: json['status'] ?? 'active',
    );
  }
}

class CounselorAnalyticsData {
  final int totalStudents;
  final double averageProgressPercent;
  final Map<String, dynamic> pathwayDistribution;
  final double quizCompletionRate;
  final List<dynamic> studentsNeedingAttention;
  final List<StudentSummary> students;

  CounselorAnalyticsData({
    required this.totalStudents,
    required this.averageProgressPercent,
    required this.pathwayDistribution,
    required this.quizCompletionRate,
    required this.studentsNeedingAttention,
    required this.students,
  });

  factory CounselorAnalyticsData.fromJson(Map<String, dynamic> json) {
    var list = json['students'] as List? ?? [];
    List<StudentSummary> studentList = list.map((i) => StudentSummary.fromJson(i)).toList();
    return CounselorAnalyticsData(
      totalStudents: json['total_students'] ?? 0,
      averageProgressPercent: (json['average_progress_percent'] ?? 0.0).toDouble(),
      pathwayDistribution: json['pathway_distribution'] ?? {},
      quizCompletionRate: (json['quiz_completion_rate'] ?? 0.0).toDouble(),
      studentsNeedingAttention: json['students_needing_attention'] ?? [],
      students: studentList,
    );
  }
}

class CounselorDashboardScreen extends StatefulWidget {
  final CounselorProfile profile;

  const CounselorDashboardScreen({super.key, required this.profile});

  @override
  State<CounselorDashboardScreen> createState() => _CounselorDashboardScreenState();
}

class _CounselorDashboardScreenState extends State<CounselorDashboardScreen> {
  AsyncViewState _state = AsyncViewState.loading;
  CounselorAnalyticsData? _analytics;
  final TextEditingController _noteController = TextEditingController();
  String? _inviteCode;

  @override
  void initState() {
    super.initState();
    _fetchAnalytics();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _fetchAnalytics() async {
    setState(() => _state = AsyncViewState.loading);
    try {
      final response = await ApiClient.get('/counselor/analytics');
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        setState(() {
          _analytics = CounselorAnalyticsData.fromJson(decoded);
          _state = (_analytics?.students.isEmpty ?? true) ? AsyncViewState.empty : AsyncViewState.data;
        });
      } else {
        setState(() => _state = AsyncViewState.error);
      }
    } catch (e) {
      debugPrint("Error fetching counselor analytics: $e");
      setState(() => _state = AsyncViewState.error);
    }
  }

  Future<void> _generateInviteCode() async {
    try {
      final response = await ApiClient.post('/counselor-link/generate', {});
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        setState(() {
          _inviteCode = decoded['code'];
        });
        if (mounted) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text("Student Invite Code"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Share this code with your student so they can link their account to your counselor profile:"),
                  const SizedBox(height: 16),
                  SelectableText(
                    _inviteCode ?? '',
                    style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: RoadmapColors.primaryTeal),
                  ),
                  const SizedBox(height: 12),
                  const Text("Code expires in 24 hours.", style: TextStyle(fontSize: 12, color: RoadmapColors.textMuted)),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Done"),
                )
              ],
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to generate code")));
      }
    }
  }

  void _postNote() {
    final text = _noteController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write a note'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Note posted to your students'),
        backgroundColor: RoadmapColors.primaryTeal,
      ),
    );
    _noteController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RoadmapColors.bgLight,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: AsyncStateView(
              state: _state,
              onRetry: _fetchAnalytics,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAnalyticsSummaryCards(),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.between,
                      children: [
                        Text(
                          "Linked Students (${_analytics?.totalStudents ?? 0})",
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: RoadmapColors.textDark,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _generateInviteCode,
                          icon: const Icon(Icons.add_link, size: 16, color: RoadmapColors.primaryTeal),
                          label: Text("Link Student", style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: RoadmapColors.primaryTeal)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_analytics != null && _analytics!.students.isNotEmpty)
                      ..._analytics!.students.map((student) => _buildStudentCard(student, context))
                    else
                      Container(
                        padding: const EdgeInsets.all(24),
                        alignment: Alignment.center,
                        child: Text("No linked students yet. Tap 'Link Student' to generate an invite code.", textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 13, color: RoadmapColors.textMuted)),
                      ),
                    const SizedBox(height: 24),
                    Text(
                      "Post Announcement / Guidance Note",
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: RoadmapColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _noteController,
                      maxLines: 3,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: RoadmapColors.textDark,
                      ),
                      decoration: InputDecoration(
                        hintText:
                            "Share local guidance — e.g. 'Our school's ECAT prep classes start in March'",
                        hintStyle: GoogleFonts.inter(
                          fontSize: 13,
                          color: RoadmapColors.textMuted,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: RoadmapColors.borderLight,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: RoadmapColors.borderLight,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: RoadmapColors.primaryTeal,
                            width: 1.5,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _postNote,
                      child: Container(
                        width: double.infinity,
                        height: 48,
                        decoration: BoxDecoration(
                          color: RoadmapColors.primaryTeal,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            "Post to My Students",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
            Text(
              "Counselor Dashboard",
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFFD9EDEA),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.profile.institutionName,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );

  Widget _buildAnalyticsSummaryCards() {
    if (_analytics == null) return const SizedBox.shrink();
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            "Avg Progress",
            "${_analytics!.averageProgressPercent.toInt()}%",
            Icons.trending_up,
            RoadmapColors.primaryTeal,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            "Quiz Complete",
            "${_analytics!.quizCompletionRate.toInt()}%",
            Icons.quiz_outlined,
            Colors.amber.shade800,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: RoadmapColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.between,
            children: [
              Text(title, style: GoogleFonts.inter(fontSize: 12, color: RoadmapColors.textMuted)),
              Icon(icon, size: 18, color: color),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: RoadmapColors.textDark),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(StudentSummary student, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: RoadmapColors.borderLight),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      student.name,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: RoadmapColors.textDark,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: student.status == 'needs-attention' ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        student.status == 'needs-attention' ? 'Needs Attention' : 'On Track',
                        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: student.status == 'needs-attention' ? Colors.red : Colors.green),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "${student.pathwayTitle} · ${student.stepsDone}/${student.totalSteps} steps",
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: RoadmapColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${student.progressPercent.toInt()}%",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: RoadmapColors.primaryTeal,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "View Roadmap →",
                style: GoogleFonts.inter(fontSize: 10, color: RoadmapColors.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
