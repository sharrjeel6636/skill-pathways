import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

class CounselorOnboardingScreen extends StatefulWidget {
  const CounselorOnboardingScreen({super.key});

  @override
  State<CounselorOnboardingScreen> createState() => _CounselorOnboardingScreenState();
}

class _CounselorOnboardingScreenState extends State<CounselorOnboardingScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RoadmapColors.bgLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text("Counselor Setup", style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: RoadmapColors.textDark)),
              const SizedBox(height: 24),
              Text("Which school/institute are you affiliated with?", style: GoogleFonts.inter(fontSize: 14, color: RoadmapColors.textMuted)),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Enter school name",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CounselorDashboardScreen(profile: CounselorProfile(name: "Test Counselor", institutionName: _controller.text, linkedStudentIds: []))));
                },
                child: Container(
                  width: double.infinity, height: 52,
                  decoration: BoxDecoration(color: RoadmapColors.primaryTeal, borderRadius: BorderRadius.circular(14)),
                  child: Center(child: Text("Continue", style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
