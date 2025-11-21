import 'package:flutter/material.dart';

/// Application color scheme following Material Design 3 guidelines
class AppColors {
  AppColors._();

  // Light Theme Colors
  static const Color primaryLight = Color(0xFF1976D2); // Blue
  static const Color primaryContainerLight = Color(0xFFBBDEFB);
  static const Color secondaryLight = Color(0xFF03DAC6); // Teal
  static const Color secondaryContainerLight = Color(0xFFB2DFDB);
  static const Color errorLight = Color(0xFFB00020);
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color onSecondaryLight = Color(0xFF000000);
  static const Color onBackgroundLight = Color(0xFF000000);
  static const Color onSurfaceLight = Color(0xFF000000);
  static const Color onErrorLight = Color(0xFFFFFFFF);

  // Dark Theme Colors
  static const Color primaryDark = Color(0xFF64B5F6); // Light Blue
  static const Color primaryContainerDark = Color(0xFF1565C0);
  static const Color secondaryDark = Color(0xFF80CBC4); // Light Teal
  static const Color secondaryContainerDark = Color(0xFF00897B);
  static const Color errorDark = Color(0xFFCF6679);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color onPrimaryDark = Color(0xFF000000);
  static const Color onSecondaryDark = Color(0xFF000000);
  static const Color onBackgroundDark = Color(0xFFFFFFFF);
  static const Color onSurfaceDark = Color(0xFFFFFFFF);
  static const Color onErrorDark = Color(0xFF000000);

  // Additional Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // QR Code specific colors
  static const Color qrForeground = Color(0xFF000000);
  static const Color qrBackground = Color(0xFFFFFFFF);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1976D2), Color(0xFF1565C0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF03DAC6), Color(0xFF018786)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
