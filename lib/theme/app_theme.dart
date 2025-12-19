import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Elegant dark theme with gold/amber accents
  static const Color primaryDark = Color(0xFF0A0A0F);
  static const Color secondaryDark = Color(0xFF12121A);
  static const Color cardDark = Color(0xFF1A1A24);
  static const Color accentGold = Color(0xFFD4AF37);
  static const Color accentGoldLight = Color(0xFFE8C547);
  static const Color textPrimary = Color(0xFFF5F5F5);
  static const Color textSecondary = Color(0xFFB0B0B8);
  static const Color textMuted = Color(0xFF707078);
  static const Color dividerColor = Color(0xFF2A2A35);
  static const Color glowColor = Color(0x40D4AF37);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: primaryDark,
      primaryColor: accentGold,
      colorScheme: const ColorScheme.dark(
        primary: accentGold,
        secondary: accentGoldLight,
        surface: cardDark,
        onPrimary: primaryDark,
        onSecondary: primaryDark,
        onSurface: textPrimary,
      ),
      textTheme: TextTheme(
        // DM Sans for titles (bold)
        displayLarge: GoogleFonts.dmSans(
          fontSize: 72,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: 2,
        ),
        displayMedium: GoogleFonts.dmSans(
          fontSize: 48,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: 1,
        ),
        displaySmall: GoogleFonts.dmSans(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        headlineLarge: GoogleFonts.dmSans(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        headlineMedium: GoogleFonts.dmSans(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        headlineSmall: GoogleFonts.dmSans(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        titleLarge: GoogleFonts.dmSans(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        titleMedium: GoogleFonts.dmSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textSecondary,
        ),
        // Poppins for body/descriptions
        bodyLarge: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: textSecondary,
          height: 1.7,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textSecondary,
          height: 1.6,
        ),
        bodySmall: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textMuted,
        ),
        labelLarge: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        labelMedium: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),
        labelSmall: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: textMuted,
        ),
      ),
    );
  }

  // Responsive breakpoints
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 768;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 768 &&
      MediaQuery.of(context).size.width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  static double getHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 768) return 24;
    if (width < 1200) return 48;
    return width * 0.1;
  }

  static double getMaxContentWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 768) return width - 48;
    if (width < 1200) return width - 96;
    return 1000;
  }
}

// Elegant gradient decorations
class AppDecorations {
  static BoxDecoration get cardDecoration => BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.dividerColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      );

  static BoxDecoration get glowingCircle => BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.accentGold,
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentGold.withValues(alpha: 0.5),
            blurRadius: 12,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: AppTheme.accentGold.withValues(alpha: 0.3),
            blurRadius: 24,
            spreadRadius: 4,
          ),
        ],
      );

  static LinearGradient get subtleGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppTheme.primaryDark,
          AppTheme.secondaryDark.withValues(alpha: 0.8),
          AppTheme.primaryDark,
        ],
      );

  static LinearGradient get goldGradient => const LinearGradient(
        colors: [
          AppTheme.accentGold,
          AppTheme.accentGoldLight,
          AppTheme.accentGold,
        ],
      );
}

