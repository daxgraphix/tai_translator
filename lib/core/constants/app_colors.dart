import 'package:flutter/material.dart';

/// Minimalist palette: White, Blue, Black.
class AppColors {
  AppColors._();

  // Main Blue
  static const Color primaryBlue = Color(0xFF2563EB); 
  
  // Strict Colors
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color pureBlack = Color(0xFF000000);

  // Light Theme
  static const Color backgroundLight = pureWhite;
  static const Color surfaceLight = pureWhite;
  static const Color textLight = pureBlack;

  // Dark Theme
  static const Color backgroundDark = pureBlack;
  static const Color surfaceDark = pureBlack;
  static const Color textDark = pureWhite;

  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
}
