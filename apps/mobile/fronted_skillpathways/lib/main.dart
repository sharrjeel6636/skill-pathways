import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
              Positioned(top: 0, left: 0, right: 0, child: _buildStatusBar()),
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

  // Add this to update navigation in DiscoveryScreen or other screens later
  void _navigateToHome() => setState(() => _currentScreen = 'home');

  Widget _buildStatusBar() {
    final isDark = _currentScreen == 'onboarding';
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      color: isDark ? const Color(0xFF0B766F) : const Color(0xFFF8F5F0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("09:41", style: GoogleFonts.inter(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.w600, fontSize: 13)),
          Container(width: 85, height: 20, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10))),
          Icon(Icons.battery_5_bar, color: isDark ? Colors.white : Colors.black, size: 15),
        ],
      ),
    );
  }
}

// ============================================================================
// AUTH SCREEN (LOGIN & SIGN UP)
// ============================================================================

class AuthScreen extends StatefulWidget {
  final VoidCallback onSuccess;
  const AuthScreen({super.key, required this.onSuccess});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 80),
            _buildTopHeader(),
            const SizedBox(height: 40),
            _buildToggleTabs(),
            const SizedBox(height: 40),
            _buildHeadline(),
            const SizedBox(height: 32),
            _buildForm(),
            const SizedBox(height: 32),
            _buildPrimaryButton(),
            if (_isLogin) _buildForgotPassword(),
            const SizedBox(height: 32),
            _buildSocialSection(),
            const SizedBox(height: 40),
            _buildFooterToggle(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader() => Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 32, height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFF0B766F),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: 12, height: 12,
                decoration: const BoxDecoration(color: Color(0xFFF5A20B), shape: BoxShape.circle),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            "Skill Pathway",
            style: GoogleFonts.inter(
              color: const Color(0xFF1E2022),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Text(
        "Matric se career tak, guided rasta",
        style: GoogleFonts.inter(
          color: const Color(0xFF7E8A87),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );

  Widget _buildToggleTabs() => Container(
    height: 52,
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
      ],
    ),
    child: Row(
      children: [
        _buildTab("Login", _isLogin),
        _buildTab("Sign Up", !_isLogin),
      ],
    ),
  );

  Widget _buildTab(String title, bool isActive) => Expanded(
    child: GestureDetector(
      onTap: () => setState(() => _isLogin = title == "Login"),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF0B766F) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.inter(
              color: isActive ? Colors.white : const Color(0xFF7E8A87),
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ),
    ),
  );

  Widget _buildHeadline() => Align(
    alignment: Alignment.centerLeft,
    child: Text(
      _isLogin ? "Welcome back" : "Create your account",
      style: GoogleFonts.merriweather(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF1E2022),
      ),
    ),
  );

  Widget _buildForm() => Column(
    children: [
      if (!_isLogin) ...[
        _buildInputField("Full Name", Icons.person_outline),
        const SizedBox(height: 16),
      ],
      _buildInputField("Email or Phone number", Icons.mail_outline),
      const SizedBox(height: 16),
      _buildInputField(
        "Password", 
        Icons.lock_outline, 
        isPassword: true,
        suffix: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: const Color(0xFF7E8A87),
            size: 20,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
      if (!_isLogin) ...[
        const SizedBox(height: 16),
        _buildInputField("Confirm Password", Icons.lock_outline, isPassword: true),
      ],
    ],
  );

  Widget _buildInputField(String hint, IconData icon, {bool isPassword = false, Widget? suffix}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFE8E7E3), width: 1.5),
    ),
    child: TextField(
      obscureText: isPassword && _obscurePassword,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(color: const Color(0xFF7E8A87), fontSize: 14),
        prefixIcon: Icon(icon, color: const Color(0xFF0B766F), size: 20),
        suffixIcon: suffix,
        border: InputBorder.none,
      ),
    ),
  );

  Widget _buildPrimaryButton() => GestureDetector(
    onTap: widget.onSuccess,
    child: Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFF0B766F),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: const Color(0xFF0B766F).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Center(
        child: Text(
          _isLogin ? "Login" : "Create Account",
          style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    ),
  );

  Widget _buildForgotPassword() => Padding(
    padding: const EdgeInsets.only(top: 16),
    child: Text(
      "Forgot Password?",
      style: GoogleFonts.inter(
        color: const Color(0xFF0B766F),
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
    ),
  );

  Widget _buildSocialSection() => Column(
    children: [
      Row(
        children: [
          Expanded(child: Divider(color: const Color(0xFFE8E7E3), thickness: 1.5)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "or continue with",
              style: GoogleFonts.inter(color: const Color(0xFF7E8A87), fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Divider(color: const Color(0xFFE8E7E3), thickness: 1.5)),
        ],
      ),
      const SizedBox(height: 24),
      Row(
        children: [
          _buildSocialButton("Google", Icons.g_mobiledata),
          const SizedBox(width: 16),
          _buildSocialButton("Apple", Icons.apple),
        ],
      ),
    ],
  );

  Widget _buildSocialButton(String label, IconData icon) => Expanded(
    child: Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8E7E3), width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 8),
          Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    ),
  );

  Widget _buildFooterToggle() => GestureDetector(
    onTap: () => setState(() => _isLogin = !_isLogin),
    child: Text.rich(
      TextSpan(
        text: _isLogin ? "Don’t have an account? " : "Already have an account? ",
        style: GoogleFonts.inter(color: const Color(0xFF7E8A87), fontSize: 14),
        children: [
          TextSpan(
            text: _isLogin ? "Sign Up" : "Login",
            style: GoogleFonts.inter(color: const Color(0xFF0B766F), fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}

// ============================================================================
// ONBOARDING SCREEN (UPDATED)
// ============================================================================

class OnboardingScreen extends StatelessWidget {
  final Function(String) onLanguageConfirmed;
  const OnboardingScreen({super.key, required this.onLanguageConfirmed});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F1E8), // Cream background
      child: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildBody(context)),
          _buildBottomSection(context),
        ],
      ),
    );
  }

  Widget _buildHeader() => Container(
    padding: const EdgeInsets.only(top: 64, bottom: 40, left: 24, right: 24),
    decoration: const BoxDecoration(
      color: Color(0xFF1B6F63), // Dark teal
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(32),
        bottomRight: Radius.circular(32),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 32, height: 32,
          decoration: const BoxDecoration(color: Color(0xFFFF9800), shape: BoxShape.circle), // Solid orange
        ),
        const SizedBox(width: 12),
        Text(
          "Skill Pathway",
          style: GoogleFonts.sansSerif( // Rounded sans-serif
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
      ],
    ),
  );

  Widget _buildBody(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: "Every path\n",
            style: GoogleFonts.merriweather( // Serif
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1B3022), // Dark green
              height: 1.15,
            ),
            children: [
              TextSpan(
                text: "should be visible.",
                style: GoogleFonts.merriweather(
                  fontSize: 34,
                  color: const Color(0xFF1B3022),
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            "ہر راستہ صاف نظر آنا چاہیے",
            textAlign: TextAlign.center,
            style: GoogleFonts.notoNastaliqUrdu( // Decorative script
              fontSize: 18,
              color: const Color(0xFFC45C3E), // Reddish-orange
              height: 2.2,
            ),
          ),
        ),
        const SizedBox(height: 32),
        _buildIllustration(),
        const SizedBox(height: 32),
        Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.85),
            child: Text(
              "A career-guidance companion for students who feel lost between too much advice and not enough proof. The design's one job: turn 'I don't know what path to take' into a path you can see, trust, and walk — one unlocked step at a time.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: const Color(0xFF7E8A87), // Grey color
                fontSize: 13.5,
                height: 1.6,
              ),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _buildIllustration() => Center(
    child: SizedBox(
      width: 220,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Circles cluster
          Positioned(left: 30, top: 0, child: _circle(100, const Color(0xFF1B6F63).withOpacity(0.15))),
          Positioned(right: 30, top: 20, child: _circle(90, const Color(0xFFC4A43E).withOpacity(0.15))),
          Positioned(left: 50, bottom: 0, child: _circle(110, const Color(0xFFE47A6E).withOpacity(0.12))),
          Positioned(right: 70, top: 40, child: _circle(40, const Color(0xFFFF9800).withOpacity(0.2))),

          // White Document Icon centered on top of circles
          Container(
            width: 72, height: 72,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, 8))
              ],
            ),
            child: Center(
              child: Stack(
                children: [
                  const Icon(Icons.insert_drive_file_outlined, size: 36, color: Color(0xFF1B6F63)),
                  Positioned(right: 8, top: 12, child: Container(width: 16, height: 2, color: const Color(0xFF1B6F63).withOpacity(0.3))),
                  Positioned(right: 8, top: 18, child: Container(width: 16, height: 2, color: const Color(0xFF1B6F63).withOpacity(0.3))),
                  Positioned(right: 8, top: 24, child: Container(width: 12, height: 2, color: const Color(0xFF1B6F63).withOpacity(0.3))),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildBottomSection(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Choose your language",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 20),
        _buildLanguageCard("English", isEnglish: true, () => onLanguageConfirmed("English")),
        const SizedBox(height: 16),
        _buildLanguageCard("اردو", isEnglish: false, () => onLanguageConfirmed("Urdu")),
      ],
    ),
  );

  Widget _buildLanguageCard(String language, VoidCallback onTap, {required bool isEnglish}) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40), // pill shape
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          language,
          style: isEnglish
              ? GoogleFonts.inter(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                )
              : GoogleFonts.notoNastaliqUrdu(
                  color: const Color(0xFFC45C3E),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
        ),
      ),
    ),
  );
}


// ============================================================================
// HOME SCREEN
// ============================================================================

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0), // Warm cream background
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildQuizCard(),
                  const SizedBox(height: 24),
                  _buildSectionTitle("Your Roadmap"),
                  const SizedBox(height: 16),
                  _buildRoadmap(),
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
      color: Color(0xFF0B766F), // Deep teal
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
            color: const Color(0xFFE0F2F1), // Soft light teal
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

  Widget _buildQuizCard() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: const Color(0xFFF5A20B), // Orange Quiz Card
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Take your Aptitude Quiz",
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E2022),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Find out if Science, Arts or Commerce fits you best — 5 mins",
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF1E2022).withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF1E2022), // Dark charcoal
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "Start Quiz Now →",
            style: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _buildSectionTitle(String title) => Text(
    title,
    style: GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF1E2022),
    ),
  );

  Widget _buildRoadmap() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xFFE8E7E3)),
    ),
    child: Column(
      children: [
        _buildRoadmapStep("Aptitude test completed", "Result: Pre-Engineering fit", isCompleted: true),
        _buildRoadmapStep("Strengthen Math & Physics", "", isLocked: true),
        _buildRoadmapStep("Explore Intermediate options", "", isLocked: true),
      ],
    ),
  );

  Widget _buildRoadmapStep(String title, String subtitle, {bool isCompleted = false, bool isLocked = false}) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Row(
      children: [
        Container(
          width: 30, height: 30,
          decoration: BoxDecoration(
            color: isCompleted ? const Color(0xFF0B766F) : (isLocked ? const Color(0xFFE8E7E3) : Colors.transparent),
            shape: BoxShape.circle,
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
            Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            if (subtitle.isNotEmpty) Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF7E8A87))),
          ],
        ),
      ],
    ),
  );

  Widget _buildParentsCard() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: const Color(0xFFE0F2F1), // Soft light teal
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
      style: GoogleFonts.merriweather(fontStyle: FontStyle.italic, color: const Color(0xFF1E2022)),
    ),
  );

  Widget _buildBottomNavBar() => Container(
    color: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 12),
    decoration: const BoxDecoration(
      border: Border(top: BorderSide(color: Color(0xFFE8E7E3))),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _navItem(Icons.home, "Home", isActive: true),
        _navItem(Icons.map_outlined, "Roadmap"),
        _navItem(Icons.chat_bubble_outline, "Chatbot"),
        _navItem(Icons.person_outline, "Profile"),
      ],
    ),
  );

  Widget _navItem(IconData icon, String label, {bool isActive = false}) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, color: isActive ? const Color(0xFF0B766F) : const Color(0xFF7E8A87)),
      const SizedBox(height: 4),
      Text(label, style: GoogleFonts.inter(fontSize: 10, color: isActive ? const Color(0xFF0B766F) : const Color(0xFF7E8A87))),
    ],
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
      backgroundColor: const Color(0xFFF8F5F0), // Warm cream background
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
            color: isSelected ? const Color(0xFFE6F2F1) : Colors.white,
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
