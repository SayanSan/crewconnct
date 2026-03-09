import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Brand Palette ──────────────────────────────────────────────────────
  static const Color primary = Color(0xFF4F46E5);       // Indigo 600
  static const Color primaryLight = Color(0xFF818CF8);   // Indigo 400
  static const Color primaryDark = Color(0xFF3730A3);    // Indigo 800
  static const Color secondary = Color(0xFF06B6D4);      // Cyan 500
  static const Color secondaryLight = Color(0xFF67E8F9); // Cyan 300
  static const Color accent = Color(0xFFF59E0B);         // Amber 500

  // ── Gradients ──────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF7C3AED)],  // Indigo → Violet
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1E1B4B), Color(0xFF312E81)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ── Dark Theme ─────────────────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF0F172A);    // Slate 900
  static const Color darkSurface = Color(0xFF1E293B);       // Slate 800
  static const Color darkCard = Color(0xFF334155);           // Slate 700
  static const Color darkBorder = Color(0xFF475569);         // Slate 600
  static const Color darkTextPrimary = Color(0xFFF8FAFC);    // Slate 50
  static const Color darkTextSecondary = Color(0xFF94A3B8);  // Slate 400
  static const Color darkTextTertiary = Color(0xFF64748B);   // Slate 500

  // ── Light Theme ────────────────────────────────────────────────────────
  static const Color lightBackground = Color(0xFFF8FAFC);   // Slate 50
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFF1F5F9);         // Slate 100
  static const Color lightBorder = Color(0xFFE2E8F0);       // Slate 200
  static const Color lightTextPrimary = Color(0xFF0F172A);   // Slate 900
  static const Color lightTextSecondary = Color(0xFF475569); // Slate 600
  static const Color lightTextTertiary = Color(0xFF94A3B8);  // Slate 400

  // ── Status Colors ──────────────────────────────────────────────────────
  static const Color success = Color(0xFF10B981);   // Emerald 500
  static const Color warning = Color(0xFFF59E0B);   // Amber 500
  static const Color error = Color(0xFFEF4444);     // Red 500
  static const Color info = Color(0xFF3B82F6);      // Blue 500

  // ── Application Status Colors ──────────────────────────────────────────
  static const Color applied = Color(0xFF3B82F6);
  static const Color shortlisted = Color(0xFFF59E0B);
  static const Color accepted = Color(0xFF10B981);
  static const Color rejected = Color(0xFFEF4444);
}
