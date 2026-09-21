import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum UserRole { student, parent, counselor }

class RoleSelectionScreen extends StatefulWidget {
  final Function(UserRole) onContinue;

  const RoleSelectionScreen({super.key, required this.onContinue});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  UserRole _selectedRole = UserRole.student;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 100),
              Text("Who's using Skill Pathway?", style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF1C1917))),
              const SizedBox(height: 32),
              _buildRoleCard(
                role: UserRole.student,
                title: "I'm a Student",
                subtitle: "Get guidance for your own path",
              ),
              const SizedBox(height: 16),
              _buildRoleCard(
                role: UserRole.parent,
                title: "I'm a Parent",
                subtitle: "Track and support your child",
              ),
              const SizedBox(height: 16),
              _buildRoleCard(
                role: UserRole.counselor,
                title: "I'm a Teacher/Counselor",
                subtitle: "Support students at your school",
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => widget.onContinue(_selectedRole),
                child: Container(
                  width: double.infinity, height: 52,
                  decoration: BoxDecoration(color: const Color(0xFF0F766E), borderRadius: BorderRadius.circular(14)),
                  child: Center(child: Text("Continue", style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white))),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({required UserRole role, required String title, required String subtitle}) {
    final isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE9F5F3) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: isSelected ? const Color(0xFF0F766E) : const Color(0xFFE7E5E4), width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: const BoxDecoration(color: Color(0xFFF59E0B), shape: BoxShape.circle),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF1C1917))),
                  const SizedBox(height: 4),
                  Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF6B7280))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
