import 'package:flutter/material.dart';

/// Paleta extraída dos brasões de referência (azul-marinho + azul-gelo).
class AppColors {
  AppColors._();

  static const navy = Color(0xFF132A4C);
  static const navyDark = Color(0xFF0E1F38);
  static const powderBlue = Color(0xFFC5DCE8);
  static const powderBlueLight = Color(0xFFEAF3F8);

  /// Fundo levemente acinzentado (estilo dashboard), cartões ficam brancos
  /// por cima com sombra suave para dar profundidade.
  static const scaffoldBg = Color(0xFFF4F7FA);
  static const cardBg = Color(0xFFFFFFFF);
  static const textMuted = Color(0xFF6B7A90);

  static const accentAmber = Color(0xFFE0A64B);
  static const accentGreen = Color(0xFF3FA672);
}

class AppTheme {
  AppTheme._();

  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: AppColors.navy.withValues(alpha: 0.06),
      blurRadius: 18,
      offset: const Offset(0, 6),
    ),
  ];

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.navy,
      primary: AppColors.navy,
      secondary: AppColors.powderBlue,
      surface: AppColors.cardBg,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.scaffoldBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.scaffoldBg,
        foregroundColor: AppColors.navyDark,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.zero,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.cardBg,
        indicatorColor: AppColors.navy,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? AppColors.navy : AppColors.textMuted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? Colors.white : AppColors.textMuted,
          );
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.navy,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.powderBlue.withValues(alpha: 0.6)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.powderBlue.withValues(alpha: 0.6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.navy, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      textTheme: ThemeData.light().textTheme.apply(
            bodyColor: AppColors.navyDark,
            displayColor: AppColors.navyDark,
          ),
    );
  }
}
