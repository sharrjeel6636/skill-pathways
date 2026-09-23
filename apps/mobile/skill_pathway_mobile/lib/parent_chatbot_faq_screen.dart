import 'package:flutter/material.dart';
import 'theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'chatbot_screen.dart';

class ParentChatbotFaqScreen extends StatefulWidget {
  const ParentChatbotFaqScreen({super.key});

  @override
  State<ParentChatbotFaqScreen> createState() => _ParentChatbotFaqScreenState();
}

class _ParentChatbotFaqScreenState extends State<ParentChatbotFaqScreen> {
  final TextEditingController _textController = TextEditingController();

  final List<String> faqs = [
    "Is this app free for parents to use",
    "How do I see my child's progress",
    "What if my child changes their mind about a field",
    "Is the university/scholarship info verified",
  ];

  void _navigateToChat(String initialMessage) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChatbotScreen(isParentMode: true),
      ),
    ).then((_) {
      // In a real implementation, we would send the initial message to the chatbot controller here
      // to pre-populate the chat if needed, though this is secondary for v1.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RoadmapColors.bgLight,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Frequently Asked",
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: RoadmapColors.textDark)),
                  const SizedBox(height: 18),
                  ...faqs.map((faq) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          onTap: () => _navigateToChat(faq),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: RoadmapColors.surfaceWhite,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: RoadmapColors.borderLight),
                            ),
                            child: Text(faq,
                                style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: RoadmapColors.textDark)),
                          ),
                        ),
                      )),
                  const Spacer(),
                ],
              ),
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildHeader() => Container(
        padding: const EdgeInsets.fromLTRB(24, 56, 24, 18),
        decoration: const BoxDecoration(color: RoadmapColors.primaryTeal),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                  color: RoadmapColors.accentAmber, shape: BoxShape.circle),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Parent Support Chat",
                    style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
                Text("Simple answers, no jargon",
                    style: GoogleFonts.inter(
                        fontSize: 11, color: const Color(0xFFD9EDEA))),
              ],
            ),
          ],
        ),
      );

  Widget _buildInputBar() => Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 26),
        decoration: const BoxDecoration(
          color: RoadmapColors.surfaceWhite,
          border: Border(top: BorderSide(color: RoadmapColors.borderLight)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F3),
                    borderRadius: BorderRadius.circular(20)),
                child: TextField(
                  controller: _textController,
                  style: GoogleFonts.inter(
                      fontSize: 13, color: RoadmapColors.textDark),
                  decoration: InputDecoration(
                    hintText: "Ask us anything...",
                    hintStyle: GoogleFonts.inter(
                        fontSize: 13, color: RoadmapColors.textMuted),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => _navigateToChat(_textController.text),
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                    color: RoadmapColors.primaryTeal, shape: BoxShape.circle),
                child: const Icon(Icons.send_rounded,
                    color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      );
}
