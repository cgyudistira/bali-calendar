import 'package:flutter/material.dart';

/// App color constants for light and dark themes
class AppColors {
  // Primary Colors (Lavender Theme)
  static const Color primary = Color(0xFF9C89FF); // Soft Lavender
  static const Color secondary = Color(0xFFFFEE58); // Soft Yellow (Not Gold)
  static const Color accent = Color(0xFF64FFDA); // Soft Teal (Highlights)
  
  // Light Theme Colors
  static const Color lightBackground = Color(0xFFF3F0FF); // Very pale lavender
  static const Color lightSurface = Color(0xFFFFFFFF); // White
  static const Color lightOnPrimary = Color(0xFFFFFFFF); // White text
  
  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF1A1625); // Dark purple-gray
  static const Color darkSurface = Color(0xFF2D2640); // Lighter purple-gray
  static const Color darkOnPrimary = Color(0xFFFFFFFF); // White text
  static const Color darkSecondary = Color(0xFFFFEE58); // Soft Yellow
  
  // Event Colors
  static const Color holyDayColor = Color(0xFFFFEE58); // Soft Yellow
  static const Color purnamaColor = Color(0xFF7C4DFF); // Deep Purple
  static const Color tilemColor = Color(0xFF1A1625); // Dark
  static const Color kajengKliwonColor = Color(0xFF64FFDA); // Soft Teal
  
  // Gradient Colors (Lavender/Purple)
  static const List<Color> primaryGradient = [
    Color(0xFF9C89FF), // Soft Lavender
    Color(0xFF7C4DFF), // Deep Purple
  ];
  
  static const List<Color> accentGradient = [
    Color(0xFFFFEE58), // Soft Yellow
    Color(0xFFFDD835), // Slightly deeper yellow
  ];
  
  // Text Colors
  static const Color textPrimary = Color(0xFF2D2640); // Dark Purple
  static const Color textSecondary = Color(0xFF7E7890); // Muted Purple
  static const Color textLight = Color(0xFFFFFFFF);
  
  // Utility Colors
  static const Color error = Color(0xFFFF5252);
  static const Color success = Color(0xFF64FFDA);
  static const Color warning = Color(0xFFFFAB40);
  static const Color info = Color(0xFF9C89FF);
}
