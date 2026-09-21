import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatelessWidget {
  final Function(String) onLanguageConfirmed;
  const OnboardingScreen({super.key, required this.onLanguageConfirmed});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F1E8),
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 10),
            _buildHeadingBlock(),
            const SizedBox(height: 10),
            _buildIllustration(),
            const SizedBox(height: 10),
            _buildParagraph(),
            const Spacer(),
            _buildLanguageBlock(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    decoration: const BoxDecoration(
      color: Color(0xFF1B6F63),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(32),
        bottomRight: Radius.circular(32),
      ),
    ),
    child: Row(
      children: [
        Container(
          width: 32, height: 32,
          decoration: const BoxDecoration(color: Color(0xFFFF9800), shape: BoxShape.circle),
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

  Widget _buildHeadingBlock() => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text.rich(
        TextSpan(
          text: "Every path\n",
          style: GoogleFonts.merriweather(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1B3022),
            height: 1.1,
          ),
          children: [
            TextSpan(
              text: "should be visible.",
              style: GoogleFonts.merriweather(
                fontSize: 28,
                color: const Color(0xFF1B3022),
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 8),
      Text(
        "ہر راستہ صاف نظر آنا چاہیے",
        textAlign: TextAlign.center,
        style: GoogleFonts.notoNastaliqUrdu(
          fontSize: 16,
          color: const Color(0xFFC45C3E),
        ),
      ),
    ],
  );

  Widget _buildIllustration() => Center(
    child: SizedBox(
      height: 80, // Reduced from 100
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(left: 30, child: _circle(60, const Color(0xFF1B6F63).withOpacity(0.15))), // Reduced size
          Positioned(right: 30, child: _circle(50, const Color(0xFFC4A43E).withOpacity(0.15))), // Reduced size
          Positioned(left: 60, child: _circle(60, const Color(0xFFE47A6E).withOpacity(0.12))), // Reduced size
          Container(
            width: 50, height: 50, // Reduced from 60
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
            ),
            child: const Center(
              child: Icon(Icons.insert_drive_file_outlined, size: 24, color: Color(0xFF1B6F63)), // Reduced size
            ),
          ),
        ],
      ),
    ),
  );

  Widget _circle(double size, Color color) => Container(
    width: size, height: size,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );

  Widget _buildParagraph() => Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        "A career-guidance companion for students who feel lost between too much advice and not enough proof.",
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.inter(
          color: const Color(0xFF7E8A87),
          fontSize: 12,
          height: 1.4,
        ),
      ),
    ),
  );

  Widget _buildLanguageBlock() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8), // Reduced vertical from 16
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
        const SizedBox(height: 8), // Reduced from 16
        _buildLanguageCard("English", isEnglish: true, () => onLanguageConfirmed("English")),
        const SizedBox(height: 8), // Reduced from 12
        _buildLanguageCard("اردو", isEnglish: false, () => onLanguageConfirmed("Urdu")),
      ],
    ),
  );

  Widget _buildLanguageCard(String language, VoidCallback onTap, {required bool isEnglish}) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Reduced vertical from 20 to reduce height
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
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
