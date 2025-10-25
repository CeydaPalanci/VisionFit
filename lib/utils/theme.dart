import 'package:flutter/material.dart';

class AppTheme {
  // Ana renkler
  static const Color primaryColor = Color(0xFF789DBC); // mavi
  static const Color secondaryColor = Color(0xFFFFE3E3); // pembe
  static const Color accentColor = Color(0xFFC9E9D2); // yeşil

  // Nötr renkler
  static const Color backgroundColor = Color(0xFFF5F5F5); // Açık gri
  static const Color surfaceColor = Colors.white;
  static const Color textColor = Color(0xFF212121); // Koyu gri
  static const Color textLightColor = Color(0xFF757575); // Orta gri

  // Durum renkleri
  static const Color successColor = Color(0xFF4CAF50); // Yeşil
  static const Color errorColor = Color(0xFFE53935); // Kırmızı
  static const Color warningColor = Color(0xFFFFA726); // Turuncu
  static const Color infoColor = Color(0xFF29B6F6); // Açık mavi

  // Gradient renkler
  static const List<Color> primaryGradient = [
    Color(0xFF1E88E5),
    Color(0xFF1565C0),
  ];

  static const List<Color> secondaryGradient = [
    Color(0xFF26A69A),
    Color(0xFF00897B),
  ];

  // Tema verileri
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        background: backgroundColor,
        error: errorColor,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textColor,
          fontSize: 60,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: textColor,
          fontSize: 40,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.italic,
        ),
        bodyLarge: TextStyle(
          color: textColor,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: textLightColor,
          fontSize: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
} 