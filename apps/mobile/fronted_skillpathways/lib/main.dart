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
      case 'discovery': return DiscoveryScreen(onBack: () => setState(() => _currentScreen = 'auth'));
      default: return OnboardingScreen(onLanguageConfirmed: _navigateToAuth);
    }
  }

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
    return Column(
      children: [
        _buildHeader(),
        Expanded(child: _buildBody()),
        _buildBottomSection(context),
      ],
    );
  }

  Widget _buildHeader() => Container(
    padding: const EdgeInsets.only(top: 64, bottom: 24, left: 24, right: 24),
    color: const Color(0xFF0B766F),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 32, height: 32,
          decoration: const BoxDecoration(color: Color(0xFFF5A20B), shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Text(
          "Skill Pathway", 
          style: GoogleFonts.inter(
            color: Colors.white, 
            fontWeight: FontWeight.bold, 
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
      ],
    ),
  );

  Widget _buildBody() => Container(
    color: const Color(0xFFF8F5F0), // Warm cream background
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: "Every path ",
            style: GoogleFonts.merriweather(
              fontSize: 34, 
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1B3022), // Dark forest green
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
        const SizedBox(height: 20),
        Text(
          "ہر راستہ صاف نظر آنا چاہیے", 
          style: GoogleFonts.notoNastaliqUrdu(
            fontSize: 22, 
            color: const Color(0xFFC45C3E), // Warm rust terracotta
            height: 1.8,
          ),
        ),
        const SizedBox(height: 52),
        Center(
          child: SizedBox(
            width: 220,
            height: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Translucent circles
                Positioned(
                  left: 20, top: 10,
                  child: Container(
                    width: 130, height: 130,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B766F).withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  right: 15, bottom: 35,
                  child: Container(
                    width: 120, height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B9467).withOpacity(0.12), // Dusty olive
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  left: 45, bottom: 5,
                  child: Container(
                    width: 110, height: 110,
                    decoration: BoxDecoration(
                      color: const Color(0xFFC45C3E).withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Clean white document icon
                Container(
                  width: 76, height: 76,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 24, offset: Offset(0, 12))
                    ],
                  ),
                  child: const Icon(Icons.description_outlined, size: 34, color: Color(0xFF0B766F)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 52),
        Text(
          "A career-guidance companion for students who feel lost between too much advice and not enough proof. The design's one job: turn \"I don't know what path to take\" into a path you can see, trust, and walk — one unlocked step at a time.",
          style: GoogleFonts.inter(
            color: const Color(0xFF4A4A4A), // Soft charcoal gray
            fontSize: 15, 
            height: 1.7,
            letterSpacing: -0.1,
          ),
        ),
      ],
    ),
  );

  Widget _buildBottomSection(BuildContext context) => Container(
    color: const Color(0xFFF8F5F0),
    padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Choose your language", 
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold, 
            fontSize: 17, 
            color: const Color(0xFF1E2022),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 20),
        _buildLanguageCard("English", "Dark", () => onLanguageConfirmed("English")),
        const SizedBox(height: 16),
        _buildLanguageCard("اردو", "Nastaliq", () => onLanguageConfirmed("Urdu")),
      ],
    ),
  );

  Widget _buildLanguageCard(String language, String fontType, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04), 
            blurRadius: 16, 
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Text(
        language,
        textAlign: fontType == "Nastaliq" ? TextAlign.right : TextAlign.left,
        style: fontType == "Nastaliq"
            ? GoogleFonts.notoNastaliqUrdu(
                color: const Color(0xFFC45C3E), 
                fontSize: 20, 
                fontWeight: FontWeight.bold,
              )
            : GoogleFonts.inter(
                color: const Color(0xFF1E2022), 
                fontSize: 17, 
                fontWeight: FontWeight.w600,
              ),
      ),
    ),
  );
}

// ============================================================================
// DISCOVERY SCREEN (COMPLETED)
// ============================================================================

class DiscoveryScreen extends StatefulWidget {
  final VoidCallback onBack;
  const DiscoveryScreen({super.key, required this.onBack});

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
    onTap: () {},
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
