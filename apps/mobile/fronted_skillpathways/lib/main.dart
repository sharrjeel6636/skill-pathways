import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth_screen.dart';
import 'quiz_screen.dart';
import 'quiz_model.dart';
import 'chatbot_screen.dart';

void main() {
  runApp(const SkillPathwayApp());
}

class SkillPathwayApp extends StatelessWidget {
  const SkillPathwayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skill Pathway',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF1E2022),
      ),
      home: const OnboardingPresenter(),
    );
  }
}

class OnboardingPresenter extends StatefulWidget {
  const OnboardingPresenter({super.key});

  @override
  State<OnboardingPresenter> createState() => _OnboardingPresenterState();
}

class _OnboardingPresenterState extends State<OnboardingPresenter> {
  String _currentScreen = 'onboarding';
  String _selectedLanguage = 'English';

  void _navigateToAuth(String language) => setState(() { _selectedLanguage = language; _currentScreen = 'auth'; });
  void _navigateToDiscovery() => setState(() => _currentScreen = 'discovery');
  void _navigateToOnboarding() => setState(() => _currentScreen = 'onboarding');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 480) {
            return _buildMockupFrame(constraints);
          }
          return Scaffold(
            backgroundColor: const Color(0xFFFAFAF7),
            body: SafeArea(child: _renderCurrentScreen()),
          );
        },
      ),
    );
  }

  Widget _buildMockupFrame(BoxConstraints constraints) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF121416), Color(0xFF1E2225)], begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      child: Center(
        child: Container(
          width: 390,
          height: 844,
          margin: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAF7),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 40, offset: const Offset(0, 20))],
            border: Border.all(color: const Color(0xFF2C3236), width: 12),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
                child: _renderCurrentScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderCurrentScreen() {
    switch (_currentScreen) {
      case 'onboarding': return OnboardingScreen(onLanguageConfirmed: _navigateToAuth);
      case 'auth': return AuthScreen(onSuccess: _navigateToDiscovery);
      case 'discovery': return DiscoveryScreen(
        onBack: () => setState(() => _currentScreen = 'auth'),
        onContinue: _navigateToHome,
      );
      case 'home': return const HomeScreen();
      default: return OnboardingScreen(onLanguageConfirmed: _navigateToAuth);
    }
  }

  void _navigateToHome() => setState(() => _currentScreen = 'home');
}

// ============================================================================
// END OF AUTH SCREEN (LOGIN & SIGN UP)
// ============================================================================

// ============================================================================
// HOME SCREEN
// ============================================================================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final result = QuizState.completedResult;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF7),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildQuizCard(context, result),
                  const SizedBox(height: 24),
                  _buildSectionTitle("Your Roadmap"),
                  const SizedBox(height: 16),
                  _buildRoadmap(result),
                  const SizedBox(height: 24),
                  _buildParentsCard(),
                  const SizedBox(height: 24),
                  _buildSectionTitle("Success Stories"),
                  const SizedBox(height: 16),
                  _buildTestimonialCard(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          _buildBottomNavBar(),
        ],
      ),
    );
  }

  Widget _buildHeader() => Container(
    padding: const EdgeInsets.fromLTRB(24, 64, 24, 24),
    decoration: const BoxDecoration(
      color: Color(0xFF0B766F),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(32),
        bottomRight: Radius.circular(32),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Assalam-o-Alaikum, Sharjeel",
          style: GoogleFonts.inter(
            color: const Color(0xFFE0F2F1),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Class 10 · Science Group",
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );

  Widget _buildQuizCard(BuildContext context, QuizResult? result) {
    final bool isCompleted = result != null;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5A20B),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isCompleted ? "Assessment Completed!" : "Take your Aptitude Quiz",
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E2022),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isCompleted 
              ? "Your top field is ${result.topField}. Check your roadmap for next steps."
              : "Find out if Science, Arts or Commerce fits you best — 5 mins",
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF1E2022).withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              if (isCompleted) {
                // Optionally show results again
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QuizScreen()),
                ).then((_) => setState(() {})); // Refresh when coming back
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2022),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isCompleted ? "Results Viewed ✓" : "Start Quiz Now →",
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Text(
    title,
    style: GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF1E2022),
    ),
  );

  Widget _buildRoadmap(QuizResult? result) {
    final bool isCompleted = result != null;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RoadmapScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE8E7E3)),
        ),
        child: Column(
          children: [
            _buildRoadmapStep(
              "Aptitude test completed",
              isCompleted ? "Result: ${result.topField} fit" : "Identify your strengths",
              isCompleted: isCompleted
            ),
            _buildRoadmapStep("Strengthen Math & Physics", "", isLocked: !isCompleted),
            _buildRoadmapStep("Explore Intermediate options", "", isLocked: !isCompleted),
          ],
        ),
      ),
    );
  }

  Widget _buildRoadmapStep(String title, String subtitle, {bool isCompleted = false, bool isLocked = false}) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Row(
      children: [
        Container(
          width: 30, height: 30,
          decoration: BoxDecoration(
            color: isCompleted ? const Color(0xFF0B766F) : (isLocked ? const Color(0xFFE8E7E3) : Colors.transparent),
            shape: BoxShape.circle,
            border: isCompleted ? null : Border.all(color: const Color(0xFFE8E7E3)),
          ),
          child: Icon(
            isCompleted ? Icons.check : (isLocked ? Icons.lock_outline : Icons.circle_outlined),
            color: isCompleted ? Colors.white : const Color(0xFF7E8A87),
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: const Color(0xFF1E2022))),
            if (subtitle.isNotEmpty) Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF7E8A87))),
          ],
        ),
      ],
    ),
  );

  Widget _buildParentsCard() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: const Color(0xFFE9F5F3),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      children: [
        const Icon(Icons.people_outline, color: Color(0xFF0B766F)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            "Share progress report with parents",
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0B766F),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _buildTestimonialCard() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xFFE8E7E3)),
    ),
    child: Text(
      "\"Skill Pathway helped me realize that I am better suited for Computer Science than Pre-Medical. Highly recommended!\"\n- Ahmed, Class 10",
      style: GoogleFonts.inter(fontStyle: FontStyle.italic, color: const Color(0xFF1E2022)),
    ),
  );

  Widget _buildBottomNavBar() => Container(
    padding: const EdgeInsets.symmetric(vertical: 12),
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(top: BorderSide(color: Color(0xFFE8E7E3))),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _navItem(Icons.home, "Home", isActive: true),
        _navItem(Icons.map_outlined, "Roadmap"),
        _navItem(Icons.chat_bubble_outline, "Chatbot", onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatbotScreen()));
        }),
        _navItem(Icons.person_outline, "Profile", onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
        }),
      ],
    ),
  );

  Widget _navItem(IconData icon, String label, {bool isActive = false, VoidCallback? onTap}) => GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isActive ? const Color(0xFF0B766F) : const Color(0xFF7E8A87)),
        const SizedBox(height: 4),
        Text(label, style: GoogleFonts.inter(fontSize: 10, color: isActive ? const Color(0xFF0B766F) : const Color(0xFF7E8A87))),
      ],
    ),
  );
}

class DiscoveryScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onContinue;
  const DiscoveryScreen({super.key, required this.onBack, required this.onContinue});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  String? _selectedStage;
  String? _selectedInterest;
  final TextEditingController _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF7),
      body: Column(
        children: [
          _buildDiscoveryAppBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProgressIndicator(),
                  const SizedBox(height: 32),
                  _buildHeading(),
                  const SizedBox(height: 40),
                  _buildSectionTitle("Which stage are you in"),
                  const SizedBox(height: 16),
                  _buildStageChips(),
                  const SizedBox(height: 32),
                  _buildSectionTitle("Interest area (optional)"),
                  const SizedBox(height: 16),
                  _buildInterestChips(),
                  const SizedBox(height: 32),
                  _buildSectionTitle("Your city"),
                  const SizedBox(height: 16),
                  _buildCityInput(),
                  const SizedBox(height: 56),
                  _buildContinueButton(),
                  _buildSkipButton(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscoveryAppBar() => Container(
    padding: const EdgeInsets.only(top: 48, bottom: 8, left: 12, right: 12),
    child: Row(
      children: [
        IconButton(
          onPressed: widget.onBack, 
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Color(0xFF1E2022)),
        ),
      ],
    ),
  );

  Widget _buildProgressIndicator() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(3, (index) => AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: index == 0 ? 40 : 12, 
      height: 6, 
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: index == 0 ? const Color(0xFF0B766F) : const Color(0xFFE8E7E3), 
        borderRadius: BorderRadius.circular(10),
      ),
    )),
  );

  Widget _buildHeading() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Tell us about yourself", 
        style: GoogleFonts.inter(
          fontWeight: FontWeight.bold, 
          fontSize: 28, 
          color: const Color(0xFF1E2022),
          letterSpacing: -0.5,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        "This helps us personalize your roadmap", 
        style: GoogleFonts.inter(
          color: const Color(0xFF7E8A87), 
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
      ),
    ],
  );

  Widget _buildSectionTitle(String title) => Text(
    title, 
    style: GoogleFonts.inter(
      fontWeight: FontWeight.bold, 
      fontSize: 16, 
      color: const Color(0xFF1E2022),
    ),
  );

  Widget _buildStageChips() => Wrap(
    spacing: 12, runSpacing: 12,
    children: ["Matric", "Intermediate", "University", "Job Seeking"].map((stage) {
      final isSelected = _selectedStage == stage;
      return GestureDetector(
        onTap: () => setState(() => _selectedStage = stage),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF0B766F) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isSelected 
              ? [BoxShadow(color: const Color(0xFF0B766F).withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))]
              : [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
            border: Border.all(
              color: isSelected ? const Color(0xFF0B766F) : const Color(0xFFE8E7E3), 
              width: 1.5,
            ),
          ),
          child: Text(
            stage, 
            style: GoogleFonts.inter(
              color: isSelected ? Colors.white : const Color(0xFF52615E), 
              fontWeight: FontWeight.w600, 
              fontSize: 14,
            ),
          ),
        ),
      );
    }).toList(),
  );

  Widget _buildInterestChips() => Wrap(
    spacing: 12, runSpacing: 12,
    children: ["Science", "Arts", "Commerce", "Not sure yet"].map((interest) {
      final isSelected = _selectedInterest == interest;
      return GestureDetector(
        onTap: () => setState(() => _selectedInterest = interest),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFE9F5F3) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? const Color(0xFF0B766F).withOpacity(0.4) : const Color(0xFFE8E7E3), 
              width: 1.5,
            ),
          ),
          child: Text(
            interest, 
            style: GoogleFonts.inter(
              color: isSelected ? const Color(0xFF0B766F) : const Color(0xFF52615E), 
              fontWeight: FontWeight.w600, 
              fontSize: 14,
            ),
          ),
        ),
      );
    }).toList(),
  );

  Widget _buildCityInput() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.white, 
      borderRadius: BorderRadius.circular(16), 
      border: Border.all(color: const Color(0xFFE8E7E3), width: 1.5),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
    ),
    child: TextField(
      controller: _cityController,
      style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: "e.g. Karachi, Lahore, Islamabad", 
        hintStyle: GoogleFonts.inter(color: const Color(0xFF7E8A87), fontSize: 14),
        prefixIcon: const Icon(Icons.location_on_outlined, color: Color(0xFF0B766F), size: 22), 
        border: InputBorder.none,
      ),
    ),
  );

  Widget _buildContinueButton() => GestureDetector(
    onTap: widget.onContinue,
    child: Container(
      width: double.infinity, height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFF0B766F), 
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: const Color(0xFF0B766F).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Center(
        child: Text(
          "Continue", 
          style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    ),
  );

  Widget _buildSkipButton() => Center(
    child: Padding(
      padding: const EdgeInsets.only(top: 24), 
      child: Text(
        "Skip for now", 
        style: GoogleFonts.inter(
          color: const Color(0xFF7E8A87), 
          fontSize: 14, 
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}
