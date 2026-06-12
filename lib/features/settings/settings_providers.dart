import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants.dart';
import '../../core/error_reporter.dart';

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) {
    return SettingsNotifier();
  },
);

class SettingsState {
  final String language; // 'np' | 'en'
  final double fontSize;
  final ThemeMode themeMode;

  const SettingsState({
    this.language = 'np',
    this.fontSize = 15,
    this.themeMode = ThemeMode.system,
  });

  SettingsState copyWith({
    String? language,
    double? fontSize,
    ThemeMode? themeMode,
  }) {
    return SettingsState(
      language: language ?? this.language,
      fontSize: fontSize ?? this.fontSize,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      state = SettingsState(
        language: prefs.getString(AppConstants.languageKey) ?? 'np',
        fontSize: prefs.getDouble(AppConstants.fontSizeKey) ?? 15,
        themeMode: ThemeMode.values.elementAt(
          prefs.getInt(AppConstants.themeKey) ?? 0,
        ),
      );
    } catch (e, stack) {
      ErrorReporter.report(e, stack: stack);
    }
  }

  Future<void> setLanguage(String language) async {
    state = state.copyWith(language: language);
    await _persist();
  }

  Future<void> setFontSize(double fontSize) async {
    state = state.copyWith(fontSize: fontSize);
    await _persist();
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    state = state.copyWith(themeMode: themeMode);
    await _persist();
  }

  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.languageKey, state.language);
      await prefs.setDouble(AppConstants.fontSizeKey, state.fontSize);
      await prefs.setInt(AppConstants.themeKey, state.themeMode.index);
    } catch (e, stack) {
      ErrorReporter.report(e, stack: stack);
    }
  }
}
