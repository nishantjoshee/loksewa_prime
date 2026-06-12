import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/language_provider.dart';
import '../../core/ui_strings.dart';
import 'settings_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final strings = ref.watch(uiStringsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(strings.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Semantics(
            label: strings.language,
            child: ListTile(
              leading: const Icon(Icons.language),
              title: Text(strings.language),
              subtitle: Text(
                settings.language == 'np'
                    ? strings.languageNepali
                    : strings.languageEnglish,
              ),
              trailing: SegmentedButton<String>(
                segments: [
                  ButtonSegment(
                    value: 'np',
                    label: Text(strings.languageNepali),
                  ),
                  ButtonSegment(
                    value: 'en',
                    label: Text(strings.languageEnglish),
                  ),
                ],
                selected: {settings.language},
                onSelectionChanged: (selected) {
                  ref
                      .read(settingsProvider.notifier)
                      .setLanguage(selected.first);
                },
              ),
            ),
          ),
          const Divider(),
          Semantics(
            label: strings.fontSize,
            child: ListTile(
              leading: const Icon(Icons.format_size),
              title: Text(strings.fontSize),
              subtitle: Slider(
                value: settings.fontSize,
                min: 14,
                max: 22,
                divisions: 8,
                label: '${settings.fontSize.round()}',
                onChanged: (value) {
                  ref.read(settingsProvider.notifier).setFontSize(value);
                },
              ),
            ),
          ),
          const Divider(),
          Semantics(
            label: strings.theme,
            child: ListTile(
              leading: const Icon(Icons.brightness_6),
              title: Text(strings.theme),
              subtitle: Text(_themeLabel(settings.themeMode, strings)),
              trailing: SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(
                    value: ThemeMode.system,
                    label: Icon(Icons.auto_mode),
                  ),
                  ButtonSegment(
                    value: ThemeMode.light,
                    label: Icon(Icons.light_mode),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    label: Icon(Icons.dark_mode),
                  ),
                ],
                selected: {settings.themeMode},
                onSelectionChanged: (selected) {
                  ref
                      .read(settingsProvider.notifier)
                      .setThemeMode(selected.first);
                },
              ),
            ),
          ),
          const Divider(),
          Semantics(
            label: strings.about,
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(strings.about),
              subtitle: Text(strings.appVersion),
            ),
          ),
        ],
      ),
    );
  }

  String _themeLabel(ThemeMode mode, UiStringsData strings) {
    return switch (mode) {
      ThemeMode.system => strings.themeSystem,
      ThemeMode.light => strings.themeLight,
      ThemeMode.dark => strings.themeDark,
    };
  }
}
