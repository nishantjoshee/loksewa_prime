import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/ui_strings.dart';
import 'settings_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(UiStrings.settingsNp)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Semantics(
            label: UiStrings.languageNp,
            child: ListTile(
              leading: const Icon(Icons.language),
              title: Text(UiStrings.languageNp),
              subtitle: Text(settings.language == 'np' ? 'नेपाली' : 'English'),
              trailing: SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'np',
                    label: Text(UiStrings.languageNepali),
                  ),
                  ButtonSegment(
                    value: 'en',
                    label: Text(UiStrings.languageEnglish),
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
            label: UiStrings.fontSizeNp,
            child: ListTile(
              leading: const Icon(Icons.format_size),
              title: Text(UiStrings.fontSizeNp),
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
            label: UiStrings.themeNp,
            child: ListTile(
              leading: const Icon(Icons.brightness_6),
              title: Text(UiStrings.themeNp),
              subtitle: Text(_themeLabel(settings.themeMode)),
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
            label: UiStrings.aboutNp,
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(UiStrings.aboutNp),
              subtitle: const Text(UiStrings.appVersion),
            ),
          ),
        ],
      ),
    );
  }

  String _themeLabel(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.system => UiStrings.themeSystemNp,
      ThemeMode.light => UiStrings.themeLightNp,
      ThemeMode.dark => UiStrings.themeDarkNp,
    };
  }
}
