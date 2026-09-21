import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth_screen.dart';
import 'parent_dashboard_screen.dart';
import 'main.dart'; // To access HomeScreen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSessionAndNavigate();
  }

  Future<void> _checkSessionAndNavigate() async {
    // Artificial delay to simulate session check
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Simulate session check results
    final bool isLoggedIn = false; 
    final UserRole? userRole = null; 

    if (!isLoggedIn) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthScreen()));
    } else if (userRole == UserRole.parent) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ParentDashboardScreen(
                    data: ParentDashboardData(
                      childName: "Sharjeel",
                      fieldOfInterest: "Computer Science",
                      summaryText: "Based on aptitude quiz results...",
                      roadmapProgressPercent: 45,
                      quizCompleted: true,
                      nextMilestoneLabel: "Explore Intermediate options",
                    ),
                  )));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F766E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(color: Color(0xFFF59E0B), shape: BoxShape.circle),
            ),
            const SizedBox(height: 16),
            Text("Skill Pathway", style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 16),
            Text("Guided rasta, matric se career tak", style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFFD9EDEA))),
          ],
        ),
      ),
    );
  }
}
