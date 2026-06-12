import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/settings/settings_providers.dart';
import '../ui_strings.dart';

final languageProvider = Provider<String>((ref) {
  return ref.watch(settingsProvider).language;
});

final uiStringsProvider = Provider<UiStringsData>((ref) {
  final language = ref.watch(languageProvider);
  return UiStringsData.forLanguage(language);
});
