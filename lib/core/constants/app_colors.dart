import 'package:flutter/material.dart';

class AppColors {
  // Background layers
  static const Color background = Color(0xFF0A0E1A);
  static const Color surface = Color(0xFF111827);
  static const Color cardDark = Color(0xFF1C2438);
  static const Color cardLight = Color(0xFF242D42);

  // Accents
  static const Color gold = Color(0xFFF5C842);
  static const Color goldLight = Color(0xFFFFE082);
  static const Color teal = Color(0xFF4ECDC4);
  static const Color tealLight = Color(0xFF80DEEA);
  static const Color purple = Color(0xFFA78BFA);
  static const Color purpleLight = Color(0xFFD4BBFF);
  static const Color green = Color(0xFF4ADE80);
  static const Color blue = Color(0xFF60A5FA);
  static const Color pink = Color(0xFFF472B6);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color textMuted = Color(0xFF4B5563);

  // Status
  static const Color pending = Color(0xFFFBBF24);
  static const Color accepted = Color(0xFF4ADE80);
  static const Color rejected = Color(0xFFFC6868);

  // Glassmorphism
  static const Color glassWhite = Color(0x14FFFFFF);
  static const Color glassBorder = Color(0x20FFFFFF);

  // Gradients
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFF5C842), Color(0xFFFF8C00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient tealGradient = LinearGradient(
    colors: [Color(0xFF4ECDC4), Color(0xFF2980B9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFFA78BFA), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient greenGradient = LinearGradient(
    colors: [Color(0xFF4ADE80), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient blueGradient = LinearGradient(
    colors: [Color(0xFF60A5FA), Color(0xFF2563EB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF0A0E1A), Color(0xFF111827)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
