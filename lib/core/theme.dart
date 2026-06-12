import 'package:flutter/material.dart';
import 'visual_style.dart';

class AppTheme {
  AppTheme._();

  static const _textTheme = TextTheme(
    headlineLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      height: 1.3,
    ),
    headlineMedium: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      height: 1.3,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),
    bodyLarge: TextStyle(fontSize: 17, height: 1.65, letterSpacing: 0.1),
    bodyMedium: TextStyle(fontSize: 15, height: 1.6, letterSpacing: 0.1),
    bodySmall: TextStyle(fontSize: 13, height: 1.5),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.2,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
    ),
  );

  static final _colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: StyleColors.primary,
    onPrimary: Colors.white,
    secondary: StyleColors.accent,
    onSecondary: Colors.white,
    error: const Color(0xFFE53935),
    onError: Colors.white,
    surface: StyleColors.surface,
    onSurface: StyleColors.text,
    surfaceContainerHighest: StyleColors.card,
    outline: StyleColors.border,
    outlineVariant: StyleColors.border,
  );

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: _colorScheme,
    scaffoldBackgroundColor: StyleColors.surface,
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: StyleColors.card,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(StyleColors.cardRadius),
        side: const BorderSide(color: StyleColors.border),
      ),
      margin: const EdgeInsets.only(bottom: 10),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: StyleColors.card,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(StyleColors.cardRadius),
        borderSide: const BorderSide(color: StyleColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(StyleColors.cardRadius),
        borderSide: const BorderSide(color: StyleColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(StyleColors.cardRadius),
        borderSide: const BorderSide(color: StyleColors.primary, width: 2),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: StyleColors.card,
      selectedColor: StyleColors.primary.withValues(alpha: 0.12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(StyleColors.cardRadius),
        side: const BorderSide(color: StyleColors.border),
      ),
      labelStyle: const TextStyle(
        color: StyleColors.text,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: StyleColors.card,
      surfaceTintColor: Colors.transparent,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(StyleColors.cardRadius),
      ),
      indicatorColor: StyleColors.primary.withValues(alpha: 0.12),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          fontSize: 11,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? StyleColors.primary : StyleColors.textSecondary,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: selected ? StyleColors.primary : StyleColors.textSecondary,
          size: 24,
        );
      }),
    ),
    textTheme: _textTheme,
    dividerTheme: const DividerThemeData(
      color: StyleColors.border,
      thickness: 1,
    ),
  );
}
