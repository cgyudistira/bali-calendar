import 'package:flutter/material.dart';

/// App color constants for light and dark themes
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFFFFD700); // Gold
  static const Color secondary = Color(0xFFFF6B35); // Sunset orange
  
  // Light Theme Colors
  static const Color lightBackground = Color(0xFFFAFAFA); // Off-white
  static const Color lightSurface = Color(0xFFFFFFFF); // White
  static const Color lightOnPrimary = Color(0xFF1A1A1A); // Dark text
  
  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF121212); // Dark gray
  static const Color darkSurface = Color(0xFF1E1E1E); // Slightly lighter
  static const Color darkOnPrimary = Color(0xFF1A1A1A); // Dark text
  static const Color darkSecondary = Color(0xFFFF8C42); // Lighter orange
  
  // Event Colors
  static const Color holyDayColor = Color(0xFFFFD700); // Gold
  static const Color purnamaColor = Color(0xFF2196F3); // Blue
  static const Color tilemColor = Color(0xFF2196F3); // Blue
  static const Color kajengKliwonColor = Color(0xFFF44336); // Red
  
  // Gradient Colors (Sunrise/Sunset)
  static const List<Color> sunriseGradient = [
    Color(0xFFFF6B35), // Orange
    Color(0xFFFFD700), // Gold
    Color(0xFFFF8C42), // Light orange
  ];
  
  static const List<Color> sunsetGradient = [
    Color(0xFFFF6B35), // Orange
    Color(0xFF9C27B0), // Purple
    Color(0xFF673AB7), // Deep purple
  ];
  
  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFFFFFFFF);
  
  // Utility Colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF1976D2);
}
