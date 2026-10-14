import 'package:flutter/material.dart';

/// Centralized application color palette matching the Dawem / Streakly design
/// with full Light & Dark mode neon styling.
class AppColors {
  // Brand Primary & Accent
  static const Color primary = Color(0xFF5B50E6); // Royal Purple / Indigo
  static const Color primaryLight = Color(0xFF7B72EE);
  static const Color primaryDark = Color(0xFF4538C9);

  // Dawem Logo & Brand Trajectory Colors (Light)
  static const Color dawemGreen = Color(0xFF22C55E); // Starting wave green
  static const Color dawemGreenDark = Color(0xFF16A34A);
  static const Color dawemOrange = Color(0xFFF97316); // Rising curve orange
  static const Color dawemOrangeLight = Color(0xFFFB923C);
  static const Color starGold = Color(0xFFFBBF24); // Sparkling 4-point star gold

  // Dark Mode Specific Neon Palette (matching the attached monitor photo)
  static const Color darkBackground = Color(0xFF07090E); // Deep OLED dark
  static const Color darkSurface = Color(0xFF111520);
  static const Color darkSurfaceSecondary = Color(0xFF181E2E);
  static const Color darkCard = Color(0xFF131826);
  static const Color darkCardBorder = Color(0xFF222B3D);
  static const Color darkBorder = Color(0xFF2A344A);
  static const Color darkBorderLight = Color(0xFF1E2638);

  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextMuted = Color(0xFF64748B);

  // Neon Glow Colors for Dark Mode
  static const Color neonGreen = Color(0xFF4ADE80);
  static const Color neonGreenGlow = Color(0xFF22C55E);
  static const Color neonOrange = Color(0xFFFB923C);
  static const Color neonOrangeGlow = Color(0xFFF97316);
  static const Color neonStarGold = Color(0xFFFCD34D);

  // Dark Mode Glassmorphism & Buttons
  static const Color darkTealButtonStart = Color(0xFF0E7490);
  static const Color darkTealButtonEnd = Color(0xFF0F766E);
  static const Color darkGlassBackground = Color(0x1F1E293B);
  static const Color darkGlassBorder = Color(0x33FFFFFF);

  // Gamification & Indicators
  static const Color streakFire = Color(0xFFFF6A00); // Streak badge fire
  static const Color xpYellow = Color(0xFFF59E0B); // XP badge star
  static const Color badgePurple = Color(0xFF8B5CF6);

  // Semantic Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Light Background & Surfaces
  static const Color background = Color(0xFFF8F9FE); // Ultra light modern background
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSecondary = Color(0xFFF1F3F9);
  static const Color cardShadow = Color(0x0D1F2937);

  // Typography Colors (Light)
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Borders & Dividers (Light)
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFF3F4F6);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF5B50E6), Color(0xFF7E74FA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient dawemCurveGradient = LinearGradient(
    colors: [dawemGreen, Color(0xFF84CC16), dawemOrange],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  );

  static const LinearGradient darkTealGradient = LinearGradient(
    colors: [darkTealButtonStart, darkTealButtonEnd],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient streakGradient = LinearGradient(
    colors: [Color(0xFFFFFAF0), Color(0xFFFFF3E0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient xpGradient = LinearGradient(
    colors: [Color(0xFFFEFCE8), Color(0xFFFEF9C3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
