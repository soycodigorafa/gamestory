import 'package:flutter/material.dart';

abstract final class AppColors {
  // ── Dark palette ──────────────────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF0E0E12);
  static const Color darkSurface = Color(0xFF1A1A22);
  static const Color darkSurfaceVariant = Color(0xFF24242F);
  static const Color darkPrimary = Color(0xFF7B61FF);
  static const Color darkSecondary = Color(0xFF00D9C0);
  static const Color darkError = Color(0xFFFF4D6D);
  static const Color darkOnSurface = Color(0xFFE8E8F0);
  static const Color darkMuted = Color(0xFF6B6B80);

  // ── Light palette ─────────────────────────────────────────────────────────
  static const Color lightBackground = Color(0xFFF5F5FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFEBEBF5);
  static const Color lightPrimary = Color(0xFF5B3FE0);
  static const Color lightSecondary = Color(0xFF00A896);
  static const Color lightError = Color(0xFFD32F4F);
  static const Color lightOnSurface = Color(0xFF1A1A22);
  static const Color lightMuted = Color(0xFF888899);
}
