import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color teal = Color(0xFF164B3C);
  static const Color amber = Color(0xFFE8A33D);
  static const Color rust = Color(0xFFB5502F);
  static const Color sage = Color(0xFF8FAE86);
  static const Color paper = Color(0xFFF5F2E9);
}

final ThemeData appTheme = ThemeData(
  primaryColor: AppColors.teal,
  scaffoldBackgroundColor: AppColors.paper,
  textTheme: GoogleFonts.manropeTextTheme().copyWith(
    displayLarge: GoogleFonts.fraunces(fontSize: 32, color: AppColors.teal),
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.teal,
    primary: AppColors.teal,
    secondary: AppColors.amber,
  ),
);
