import 'package:flutter/material.dart';

@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  // Text roles (5 from your table)
  final Color textPrimary; // Neutral-900 <=> Neutral-50
  final Color textSecondary; // Neutral-300 <=> Neutral-300
  final Color textAccent; // Light-Blue-900 <=> Neutral-100
  final Color textOnPrimary; // white <=> light-blue-500
  final Color textOnSecondry; // Light-Blue-600 <=> White
  final Color textPrimaryBrand; // Blue-500 <=> Light-blue-500

  // Surfaces
  final Color inputBackground; // neutral-50 <=> neutral-900
  final Color cardBackground; // neutral100 <=> neutral100

  const AppSemanticColors({
    required this.textPrimary,
    required this.textSecondary,
    required this.textAccent,
    required this.textOnPrimary,
    required this.textOnSecondry,
    required this.textPrimaryBrand,
    required this.inputBackground,
    required this.cardBackground,
  });

  @override
  AppSemanticColors copyWith({
    Color? textPrimary,
    Color? textSecondary,
    Color? textAccent,
    Color? textOnPrimary,
    Color? textOnSecondry,
    Color? textPrimaryBrand,
    Color? inputBackground,
    Color? cardBackground,
  }) {
    return AppSemanticColors(
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textAccent: textAccent ?? this.textAccent,
      textOnPrimary: textOnPrimary ?? this.textOnPrimary,
      textOnSecondry: textOnSecondry ?? this.textOnSecondry,
      textPrimaryBrand: textPrimaryBrand ?? this.textPrimaryBrand,
      inputBackground: inputBackground ?? this.inputBackground,
      cardBackground: cardBackground ?? this.cardBackground,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;

    Color _lerp(Color a, Color b) => Color.lerp(a, b, t)!;

    return AppSemanticColors(
      textPrimary: _lerp(textPrimary, other.textPrimary),
      textSecondary: _lerp(textSecondary, other.textSecondary),
      textAccent: _lerp(textAccent, other.textAccent),
      textOnPrimary: _lerp(textOnPrimary, other.textOnPrimary),
      textOnSecondry: _lerp(textOnSecondry, other.textOnSecondry),
      textPrimaryBrand: _lerp(textPrimaryBrand, other.textPrimaryBrand),
      inputBackground: _lerp(inputBackground, other.inputBackground),
      cardBackground: _lerp(cardBackground, other.cardBackground),
    );
  }
}
