import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';

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
  bool _loading = false;
  Map<String, String> _errors = {};

  void _toggleMode() {
    setState(() {
      _formState.mode = _formState.mode == AuthMode.login ? AuthMode.signup : AuthMode.login;
      _errors.clear();
    });
  }

  void _validateAndSubmit() async {
    setState(() {
      _loading = true;
      _errors.clear();
      if (_formState.identifier.isEmpty || !_formState.identifier.contains('@')) {
        _errors['identifier'] = 'Valid Email Required';
      }
      if (_formState.password.length < 6) _errors['password'] = 'Min 6 characters';
    });

    if (_errors.isNotEmpty) {
      setState(() => _loading = false);
      return;
    }

    try {
      final client = Supabase.instance.client;
      if (_formState.mode == AuthMode.signup) {
        await client.auth.signUp(
          email: _formState.identifier,
          password: _formState.password,
        );
      } else {
        await client.auth.signInWithPassword(
          email: _formState.identifier,
          password: _formState.password,
        );
      }
      if (mounted) context.go('/role-selection');
    } on AuthException catch (e) {
      String friendlyMessage;
      if (e.message.contains('Invalid login credentials')) {
        friendlyMessage = "Email or password is incorrect";
      } else if (e.message.contains('Email not confirmed')) {
        friendlyMessage = "Please confirm your email";
      } else if (e.message.contains('User already registered')) {
        friendlyMessage = "Account already exists — try Log In";
      } else {
        friendlyMessage = e.message;
      }
      setState(() {
        _errors['global'] = friendlyMessage;
        _loading = false;
      });
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(friendlyMessage), backgroundColor: Colors.red));
    } catch (e) {
      setState(() {
        _errors['global'] = 'An unexpected error occurred';
        _loading = false;
      });
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('An unexpected error occurred'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  _buildTitle(),
                  const SizedBox(height: 28),
                  if (_errors['global'] != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        _errors['global']!,
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            color: const Color(0xFFDC2626),
                            fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (_formState.mode == AuthMode.signup)
                    _buildField(
                      "Full Name",
                      "Full Name",
                      onChanged: (v) => _formState.fullName = v,
                      error: _errors['fullName'],
                    ),
                  _buildField(
                    "Email",
                    "name@example.com",
                    onChanged: (v) => _formState.identifier = v,
                    error: _errors['identifier'],
                  ),
                  _buildField(
                    "Password",
                    "••••••••",
                    isPassword: true,
                    onChanged: (v) => _formState.password = v,
                    error: _errors['password'],
                  ),
                  if (_formState.mode == AuthMode.signup)
                    _buildField(
                      "Confirm Password",
                      "••••••••",
                      isPassword: true,
                      onChanged: (v) => _formState.confirmPassword = v,
                      error: _errors['confirmPassword'],
                    ),
                  const SizedBox(height: 12),
                  _buildPrimaryButton(),
                  const SizedBox(height: 20),
                  _buildDivider(),
                  const SizedBox(height: 20),
                  _buildSecondaryButton(),
                  const SizedBox(height: 20),
                  TextButton(
                      onPressed: () => context.go('/role-selection'),
                      child: Text("Continue as Guest",
                          style: GoogleFonts.inter(
                              fontSize: 14, color: const Color(0xFF6B7280)))),
                ],
              ),
            ),
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
        decoration: BoxDecoration(color: const Color(0xFFF7F7F6), borderRadius: BorderRadius.circular(12), border: Border.all(color: error != null ? const Color(0xFFDC2626) : const Color(0xFFE7E5E4))),
        child: TextField(
          obscureText: isPassword && _obscurePassword,
          onChanged: onChanged,
          enabled: !_loading,
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
    onTap: _loading ? null : _validateAndSubmit,
    child: Container(
      width: double.infinity, height: 52,
      decoration: BoxDecoration(color: _loading ? Colors.grey : const Color(0xFF0F766E), borderRadius: BorderRadius.circular(14)),
      child: Center(child: _loading ? const CircularProgressIndicator(color: Colors.white) : Text(_formState.mode == AuthMode.login ? "Log In" : "Sign Up", style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white))),
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
    onTap: _loading ? null : _toggleMode,
    child: Container(
      width: double.infinity, height: 52,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE7E5E4))),
      child: Center(child: Text(_formState.mode == AuthMode.login ? "Create New Account" : "Already have an account Log In", style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: const Color(0xFF1C1917)))),
    ),
  );
}
