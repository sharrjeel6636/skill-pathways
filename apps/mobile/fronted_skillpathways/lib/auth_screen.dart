import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AuthMode { login, signup }

class AuthFormState {
  AuthMode mode = AuthMode.login;
  String identifier = "";
  String password = "";
  String fullName = "";
  String confirmPassword = "";
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthFormState _formState = AuthFormState();
  bool _obscurePassword = true;
  Map<String, String> _errors = {};

  void _toggleMode() {
    setState(() {
      _formState.mode = _formState.mode == AuthMode.login ? AuthMode.signup : AuthMode.login;
      _errors.clear();
    });
  }

  void _validateAndSubmit() {
    setState(() {
      _errors.clear();
      if (_formState.identifier.isEmpty) _errors['identifier'] = 'Required';
      if (_formState.password.length < 6) _errors['password'] = 'Min 6 characters';
      if (_formState.mode == AuthMode.signup) {
        if (_formState.fullName.isEmpty) _errors['fullName'] = 'Required';
        if (_formState.confirmPassword != _formState.password) _errors['confirmPassword'] = 'Passwords do not match';
      }
    });

    if (_errors.isEmpty) {
      // TODO: Perform actual authentication
      print("Submitting: ${_formState.mode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 72),
              _buildTitle(),
              const SizedBox(height: 28),
              Expanded(
                child: Column(
                  children: [
                    if (_formState.mode == AuthMode.signup) _buildField("Full Name", "Full Name", onChanged: (v) => _formState.fullName = v, error: _errors['fullName']),
                    _buildField("Phone or Email", "03xx-xxxxxxx", onChanged: (v) => _formState.identifier = v, error: _errors['identifier']),
                    _buildField("Password", "••••••••", isPassword: true, onChanged: (v) => _formState.password = v, error: _errors['password']),
                    if (_formState.mode == AuthMode.signup) _buildField("Confirm Password", "••••••••", isPassword: true, onChanged: (v) => _formState.confirmPassword = v, error: _errors['confirmPassword']),
                  ],
                ),
              ),
              _buildPrimaryButton(),
              const SizedBox(height: 28),
              _buildDivider(),
              const SizedBox(height: 28),
              _buildSecondaryButton(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(_formState.mode == AuthMode.login ? "Welcome back" : "Create your account", style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF1C1917))),
      const SizedBox(height: 4),
      Text(_formState.mode == AuthMode.login ? "Log in to continue your journey" : "Join Skill Pathway today", style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF6B7280))),
    ],
  );

  Widget _buildField(String label, String hint, {bool isPassword = false, required ValueChanged<String> onChanged, String? error}) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: const Color(0xFF1C1917))),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(color: const Color(0xFFF7F7F6), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE7E5E4))),
        child: TextField(
          obscureText: isPassword && _obscurePassword,
          onChanged: onChanged,
          style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF1C1917)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF6B7280)),
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero,
            suffixIcon: isPassword ? IconButton(icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, size: 20), onPressed: () => setState(() => _obscurePassword = !_obscurePassword)) : null,
          ),
        ),
      ),
      if (error != null) Padding(padding: const EdgeInsets.only(top: 4), child: Text(error, style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFFDC2626)))),
      const SizedBox(height: 18),
    ],
  );

  Widget _buildPrimaryButton() => GestureDetector(
    onTap: _validateAndSubmit,
    child: Container(
      width: double.infinity, height: 52,
      decoration: BoxDecoration(color: const Color(0xFF0F766E), borderRadius: BorderRadius.circular(14)),
      child: Center(child: Text(_formState.mode == AuthMode.login ? "Log In" : "Sign Up", style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white))),
    ),
  );

  Widget _buildDivider() => Row(
    children: [
      const Expanded(child: Divider(color: Color(0xFFE7E5E4))),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text("OR", style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF6B7280)))),
      const Expanded(child: Divider(color: Color(0xFFE7E5E4))),
    ],
  );

  Widget _buildSecondaryButton() => GestureDetector(
    onTap: _toggleMode,
    child: Container(
      width: double.infinity, height: 52,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE7E5E4))),
      child: Center(child: Text(_formState.mode == AuthMode.login ? "Create New Account" : "Already have an account Log In", style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: const Color(0xFF1C1917)))),
    ),
  );
}
