import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'notifications_screen.dart';

enum AppLanguage { english, urdu }

class UserProfile {
  final String name;
  final String stageLabel; 
  final String city;
  final String? avatarUrl; 
  final AppLanguage language;

  UserProfile({
    required this.name, 
    required this.stageLabel, 
    required this.city, 
    this.avatarUrl, 
    required this.language,
  });
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Mock data - should be provided by an auth or profile service
  final UserProfile _profile = UserProfile(
    name: "Sharjeel",
    stageLabel: "Class 10",
    city: "Karachi",
    language: AppLanguage.english,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF9),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMenuGroup("Account", [
                    _buildMenuItem("Edit profile"),
                    _buildMenuItem("Change language (${_profile.language == AppLanguage.english ? 'English' : 'Urdu'})"),
                    _buildMenuItem("Link parent account"),
                  ]),
                  _buildMenuGroup("Preferences", [
                    _buildMenuItem("Notifications", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen()))),
                    _buildMenuItem("City & budget settings"),
                  ]),
                  _buildMenuGroup("Support", [
                    _buildMenuItem("Help & FAQ"),
                    _buildMenuItem("Contact support"),
                    _buildMenuItem("Log out", isDestructive: true),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() => Container(
    height: 230,
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(24, 56, 24, 28),
    decoration: const BoxDecoration(color: Color(0xFF0F766E)),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(color: Color(0xFFF59E0B), shape: BoxShape.circle),
        ),
        const SizedBox(height: 12),
        Text(_profile.name, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        Text("${_profile.stageLabel} · ${_profile.city}", style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFFD9EDEA))),
      ],
    ),
  );

  Widget _buildMenuGroup(String label, List<Widget> items) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label.toUpperCase(), style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF6B7280))),
      const SizedBox(height: 12),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE7E5E4)),
        ),
        child: Column(
          children: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isLast = index == items.length - 1;
            return Container(
              decoration: isLast ? null : const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF0F0EE)))),
              child: item,
            );
          }).toList(),
        ),
      ),
      const SizedBox(height: 20),
    ],
  );

  Widget _buildMenuItem(String title, {bool isDestructive = false, VoidCallback? onTap}) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.inter(fontSize: 14, color: isDestructive ? const Color(0xFFDC2626) : const Color(0xFF1C1917))),
          const Icon(Icons.chevron_right, size: 16, color: Color(0xFFB3B3AC)),
        ],
      ),
    ),
  );
}
