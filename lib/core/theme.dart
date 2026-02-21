import 'package:flutter/material.dart';

class HeracleTheme {
  static const Color primaryPurple = Color(0xFF9181F4);
  static const Color secondaryPurple = Color(0xFFA693F4);
  static const Color bgPink = Color(0xFFFDE7E7);
  static const Color bgBlue = Color(0xFFE7F0FD);
  static const Color cardBg = Colors.white;
  static const Color textBlack = Color(0xFF1D1B20);
  static const Color textGrey = Color(0xFF666666);
  static const Color fadedText = Color(0x66757575);

  // Givingli-inspired category colors
  static const Color givingliPurple = Color(0xFFE8E4FD);
  static const Color givingliPurpleDark = Color(0xFF7B61FF);
  static const Color givingliGreen = Color(0xFFE8F5E9);
  static const Color givingliGreenDark = Color(0xFF4CAF50);
  static const Color givingliYellow = Color(0xFFFFF9C4);
  static const Color givingliYellowDark = Color(0xFFFBC02D);
  static const Color givingliPink = Color(0xFFFFEBEE);
  static const Color givingliPinkDark = Color(0xFFE91E63);
  static const Color givingliBlue = Color(0xFFE3F2FD);
  static const Color givingliBlueDark = Color(0xFF2196F3);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.transparent,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryPurple,
        primary: primaryPurple,
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textBlack,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textBlack,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: textGrey),
        bodyMedium: TextStyle(fontSize: 14, color: textGrey),
      ),
    );
  }
}
