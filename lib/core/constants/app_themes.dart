import 'package:flutter/material.dart';

class AppThemes {
  // ---------------------------
  // LIGHT THEME
  // ---------------------------
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    colorScheme: const ColorScheme.light(
      primary: Color(0xFF5A7D5C),
      primaryContainer: Color(0xFFD4E5D4),
      secondary: Color(0xFFB8D4A8),
      secondaryContainer: Color(0xFFE8F0E8),
      surface: Color(0xFFFFFFFF),
      surfaceVariant: Color(0xFFF5F7F5),
      background: Color(0xFFF5F7F5),
      error: Color(0xFFEF4444),
      onPrimary: Colors.white,
      onPrimaryContainer: Color(0xFF2F4538),
      onSecondary: Color(0xFF2F4538),
      onSurface: Color(0xFF2F4538),
      onBackground: Color(0xFF2F4538),
      onError: Colors.white,
      outline: Color(0xFFD4E5D4),
      shadow: Color(0xFF2F4538),
    ),

    // Scaffold
    scaffoldBackgroundColor: const Color(0xFFF5F7F5),

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFFFFFF),
      foregroundColor: Color(0xFF2F4538),
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: Color(0xFF2F4538)),
    ),

    // Bottom Navigation Bar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xFFFFFFFF),
      selectedItemColor: const Color(0xFF5A7D5C),
      unselectedItemColor: const Color(0xFF2F4538).withOpacity(0.6),
      elevation: 8,
    ),

    // Card
    cardTheme: CardThemeData(
      color: const Color(0xFFFFFFFF),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFD4E5D4), width: 1),
      ),
    ),

    // Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF5A7D5C),
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    // Outlined Button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF5A7D5C),
        side: const BorderSide(color: Color(0xFF5A7D5C), width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    // Text Button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF5A7D5C),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),

    // Inputs
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFFFFFFF),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD4E5D4)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD4E5D4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF5A7D5C), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFEF4444)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),

    // Icons
    iconTheme: const IconThemeData(
      color: Color(0xFF5A7D5C),
    ),

    // Dividers
    dividerTheme: const DividerThemeData(
      color: Color(0xFFD4E5D4),
      thickness: 1,
    ),
  );

  // ---------------------------
  // DARK THEME (IMPROVED CONTRAST - BRIGHTER TEXT)
  // ---------------------------
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    colorScheme: const ColorScheme.dark(
      // Vibrant primary for interactive elements
      primary: Color(0xFFA8C9AA),
      primaryContainer: Color(0xFF5A7D5C),

      // Secondary colors
      secondary: Color(0xFFB8D4A8),
      secondaryContainer: Color(0xFF3D5A3F),

      // Dark surfaces
      surface: Color(0xFF1E2922),
      surfaceVariant: Color(0xFF2A3930),
      background: Color(0xFF141A16),

      error: Color(0xFFFF6B6B),

      // MUCH BRIGHTER TEXT - almost white
      onPrimary: Color(0xFF1A2420),
      onPrimaryContainer: Color(0xFFF5F7F5),  // Very light, almost white
      onSecondary: Color(0xFF1A2420),
      onSurface: Color(0xFFF5F7F5),  // Very light, almost white (main text color)
      onBackground: Color(0xFFF5F7F5),  // Very light, almost white
      onError: Color(0xFF1A2420),

      // Visible borders
      outline: Color(0xFF5A7D5C),
      shadow: Color(0xFF000000),
    ),

    // Scaffold
    scaffoldBackgroundColor: const Color(0xFF141A16),

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E2922),
      foregroundColor: Color(0xFFF5F7F5),  // Bright text
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: Color(0xFFF5F7F5)),  // Bright icons
    ),

    // Bottom Navigation Bar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xFF1E2922),
      selectedItemColor: const Color(0xFFA8C9AA),
      unselectedItemColor: const Color(0xFFF5F7F5).withOpacity(0.6),  // Brighter unselected
      elevation: 8,
    ),

    // Card
    cardTheme: CardThemeData(
      color: const Color(0xFF1E2922),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF5A7D5C), width: 1),
      ),
    ),

    // Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFA8C9AA),
        foregroundColor: const Color(0xFF1A2420),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    // Outlined Button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFFA8C9AA),
        side: const BorderSide(color: Color(0xFFA8C9AA), width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    // Text Button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFFA8C9AA),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),

    // Inputs
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E2922),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF5A7D5C)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF5A7D5C)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFA8C9AA), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFFF6B6B)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),

    // Icons
    iconTheme: const IconThemeData(
      color: Color(0xFFA8C9AA),
    ),

    // Dividers
    dividerTheme: const DividerThemeData(
      color: Color(0xFF5A7D5C),
      thickness: 1,
    ),
  );
}