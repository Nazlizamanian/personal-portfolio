import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Dynamic dark theme with dark blue, purple, and pink accents
  static const Color primaryDark = Color(0xFF050510);      // Deep dark blue-black
  static const Color secondaryDark = Color(0xFF0A0A18);    // Dark blue tint
  static const Color cardDark = Color(0xFF10101C);         // Card with blue undertone
  
  // Accent colors - purple as primary with blue and pink accents
  static const Color accentGold = Color(0xFF9D4EDD);       // Vivid purple (main accent)
  static const Color accentGoldLight = Color(0xFFB76EF0);  // Lighter purple
  static const Color accentBlue = Color(0xFF4361EE);       // Electric blue
  static const Color accentPink = Color(0xFFE879A9);       // Soft pink accent
  static const Color accentPurple = Color(0xFF8B5CF6);     // Secondary purple
  
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFFCBD5E1);
  static const Color textMuted = Color(0xFF64748B);
  static const Color dividerColor = Color(0xFF1E293B);     // Blue-tinted divider
  static const Color glowColor = Color(0x409D4EDD);

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
        // Montserrat for headings (weight 900)
        displayLarge: GoogleFonts.montserrat(
          fontSize: 72,
          fontWeight: FontWeight.w900,
          color: textPrimary,
          letterSpacing: 2,
        ),
        displayMedium: GoogleFonts.montserrat(
          fontSize: 48,
          fontWeight: FontWeight.w900,
          color: textPrimary,
          letterSpacing: 1,
        ),
        displaySmall: GoogleFonts.montserrat(
          fontSize: 36,
          fontWeight: FontWeight.w900,
          color: textPrimary,
        ),
        headlineLarge: GoogleFonts.montserrat(
          fontSize: 32,
          fontWeight: FontWeight.w900,
          color: textPrimary,
        ),
        headlineMedium: GoogleFonts.montserrat(
          fontSize: 24,
          fontWeight: FontWeight.w900,
          color: textPrimary,
        ),
        headlineSmall: GoogleFonts.montserrat(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        titleLarge: GoogleFonts.montserrat(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        titleMedium: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: textSecondary,
        ),
        // Inter for body/descriptions
        bodyLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: textSecondary,
          height: 1.7,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textSecondary,
          height: 1.6,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textMuted,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),
        labelSmall: GoogleFonts.inter(
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

// Dynamic gradient decorations
class AppDecorations {
  // Standard border radius for cards
  static const double cardRadius = 20.0;
  static const double buttonRadius = 28.0;
  
  static BoxDecoration get cardDecoration => BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(cardRadius),
        border: Border.all(
          color: AppTheme.dividerColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      );

  static BoxDecoration get glowingCircle => BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppTheme.accentGold, AppTheme.accentGoldLight],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentGold.withValues(alpha: 0.5),
            blurRadius: 12,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: AppTheme.accentGoldLight.withValues(alpha: 0.3),
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
          const Color(0xFF0A0A1A), // Dark blue tint
          const Color(0xFF0D0D1C), // Slight purple
          AppTheme.secondaryDark,
        ],
      );

  static LinearGradient get accentGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppTheme.accentBlue,
          AppTheme.accentGold,
          AppTheme.accentGoldLight,
        ],
      );

  static LinearGradient get purpleGradient => const LinearGradient(
        colors: [
          AppTheme.accentGold,
          AppTheme.accentGoldLight,
        ],
      );
}

