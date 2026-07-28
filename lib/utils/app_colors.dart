import 'package:flutter/material.dart';

// Centralized color palette from Section 7.1 (UI/UX Design Specifications)
// Using this class avoids repeating hex codes across the app
class AppColors {
  // Private constructor prevents this class from being instantiated
  AppColors._();

  static const Color elegantBlack = Color(0xFF1A1A1A);
  static const Color goldAccent = Color(0xFFC9A84C);
  static const Color white = Color(0xFFFFFFFF);
  static const Color softGray = Color(0xFFF5F5F5);
  static const Color darkGray = Color(0xFF333333);
  static const Color lightGray = Color(0xFFE0E0E0);
  static const Color roseGold = Color(0xFFE8B4B8);
}