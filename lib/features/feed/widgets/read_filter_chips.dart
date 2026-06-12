import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/language_provider.dart';

enum ReadFilter { all, unread, read }

final readFilterProvider = StateProvider<ReadFilter>((ref) => ReadFilter.all);

class ReadFilterChips extends ConsumerWidget {
  const ReadFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(readFilterProvider);
    final strings = ref.watch(uiStringsProvider);
    final language = ref.watch(languageProvider);

    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _chip(
            label: strings.all,
            selected: filter == ReadFilter.all,
            onTap: () =>
                ref.read(readFilterProvider.notifier).state = ReadFilter.all,
          ),
          const SizedBox(width: 6),
          _chip(
            label: language == 'np' ? 'नपढिएको' : 'Unread',
            selected: filter == ReadFilter.unread,
            color: Colors.orange,
            onTap: () =>
                ref.read(readFilterProvider.notifier).state = ReadFilter.unread,
          ),
          const SizedBox(width: 6),
          _chip(
            label: language == 'np' ? 'पढिएको' : 'Read',
            selected: filter == ReadFilter.read,
            color: Colors.green,
            onTap: () =>
                ref.read(readFilterProvider.notifier).state = ReadFilter.read,
          ),
        ],
      ),
    );
  }

  Widget _chip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final chipColor = color ?? theme.colorScheme.primary;

        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: selected
                  ? chipColor.withValues(alpha: 0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected
                    ? chipColor
                    : theme.colorScheme.outline.withValues(alpha: 0.3),
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: selected
                    ? chipColor
                    : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        );
      },
    );
  }
}
