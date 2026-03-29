import 'package:flutter/material.dart';

class AppColors {
  // Background layers
  static const Color background = Color(0xFFF8F7F4); // warm off-white
  static const Color surface = Color(0xFFFFFFFF); // white nav
  static const Color cardDark = Color(0xFFFFFFFF); // white cards
  static const Color cardLight = Color(0xFFF1F5F9); // slate-100 tabs

  // Accents
  static const Color gold = Color(0xFFF59E0B); // amber-500
  static const Color goldLight = Color(0xFFFFFBEB); // amber-50
  static const Color teal = Color(0xFF0D9488); // teal-600
  static const Color tealLight = Color(0xFFF0FDFA); // teal-50
  static const Color purple = Color(0xFF5B4FD6); // indigo-600 primary
  static const Color purpleLight = Color(0xFFEEECFE); // indigo-50
  static const Color green = Color(0xFF059669); // emerald-600
  static const Color blue = Color(0xFF2563EB); // blue-600
  static const Color pink = Color(0xFFE11D48); // rose-600

  // Text
  static const Color textPrimary = Color(0xFF141520); // foreground
  static const Color textSecondary = Color(0xFF777E94); // muted-foreground
  static const Color textMuted = Color(0xFF94A3B8); // slate-400

  // Status
  static const Color pending = Color(0xFFB45309); // amber-700
  static const Color accepted = Color(0xFF047857); // emerald-700
  static const Color rejected = Color(0xFFB91C1C); // red-700

  // Glassmorphism
  static const Color glassWhite = Color(0xCCFFFFFF); // white/80
  static const Color glassBorder = Color(0xFFDDE0EA); // border-border

  // Gradients
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFCD34D), Color(0xFFF59E0B)], // amber-300 to 500
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient tealGradient = LinearGradient(
    colors: [Color(0xFF2DD4BF), Color(0xFF0D9488)], // teal-400 to 600
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFF818CF8), Color(0xFF5B4FD6)], // indigo-400 to primary
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient greenGradient = LinearGradient(
    colors: [Color(0xFF34D399), Color(0xFF059669)], // emerald-400 to 600
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient blueGradient = LinearGradient(
    colors: [Color(0xFF60A5FA), Color(0xFF2563EB)], // blue-400 to 600
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFF8F7F4), Color(0xFFFFFFFF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
