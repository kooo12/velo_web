import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color forestMistStart = Color(0xFF0F3443);
  static const Color forestMistEnd = Color(0xFF34E89E);
  static const Color bgDark = Color(0xFF0B1F1E);
  static const Color glassColor = Color(0x1AFFFFFF);
  static const Color accentColor = Color(0xFF34E89E);
  static const Color textColor = Colors.white;

  static const LinearGradient forestMistGradient = LinearGradient(
    colors: [bgDark, Color(0xFF134E5E)],
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
  );

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: forestMistStart,
      scaffoldBackgroundColor: bgDark,
      textTheme: GoogleFonts.outfitTextTheme(
        ThemeData.dark()
            .textTheme
            .apply(bodyColor: textColor, displayColor: textColor),
      ),
      colorScheme: const ColorScheme.dark(
        primary: forestMistStart,
        secondary: accentColor,
        surface: glassColor,
      ),
    );
  }

  static BoxDecoration glassDecoration(
      {double radius = 20, bool showBorder = true}) {
    return BoxDecoration(
      color: glassColor,
      borderRadius: BorderRadius.circular(radius),
      border: showBorder
          ? Border.all(color: Colors.white.withAlpha(38), width: 1.0)
          : null,
    );
  }
}
