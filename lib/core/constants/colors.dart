import 'package:flutter/material.dart';

class AppColors {
  // Primary Brand Colors (from COCO palette)
  static const Color primary = Color(0xFF5A7D5C);        // Medium green from palette
  static const Color primaryLight = Color(0xFF8FA891);   // Light green
  static const Color primarygreen = Color(0xFF3D5A3F);    // Dark green

  // Accent Colors
  static const Color accent = Color(0xFFB8D4A8);         // Light mint green
  static const Color accentDark = Color(0xFF2F4538);     // Very dark green

  // Background Colors
  static const Color background = Color(0xFFF5F7F5);     // Very light green-gray
  static const Color cardBackground = Color(0xFFFFFFFF); // White
  static const Color lightGreen = Color(0xFFD4E5D4);     // Light pastel green

  // Text Colors
  static const Color textPrimary = Color(0xFF2F4538);    // Dark green for text
  static const Color textSecondary = Color(0xFF5A7D5C);  // Medium green for secondary text
  static const Color textLight = Color(0xFF8FA891);      // Light green for subtle text
  static const Color textWhite = Colors.white;

  // UI Elements
  static const Color border = Color(0xFFD4E5D4);         // Light green border
  static const Color divider = Color(0xFFD4E5D4);
  static const Color shadow = Color(0x0F2F4538);         // Subtle dark green shadow

  // Status Colors (keeping these standard for good UX)
  static const Color success = Color(0xFF5A7D5C);        // Use brand green
  static const Color warning = Color(0xFFF59E0B);        // Orange
  static const Color error = Color(0xFFEF4444);          // Red
  static const Color info = Color(0xFF5A7D5C);           // Use brand green

  // Gradient colors (for buttons)
  static const Color gradientStart = Color(0xFF8FA891);  // Light green
  static const Color gradientEnd = Color(0xFF5A7D5C);    // Medium green
}