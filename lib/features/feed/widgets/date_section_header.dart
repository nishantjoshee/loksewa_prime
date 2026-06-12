import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/language_provider.dart';
import '../feed_providers.dart';

class DateSectionHeader extends ConsumerWidget {
  final DateGroup group;

  const DateSectionHeader({super.key, required this.group});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(uiStringsProvider);
    final theme = Theme.of(context);

    final label = switch (group.bucket) {
      DateBucket.today => strings.todayLabel,
      DateBucket.yesterday => strings.yesterdayLabel,
      DateBucket.thisWeek => strings.thisWeekLabel,
      DateBucket.older => strings.olderLabel,
    };

    final isToday = group.bucket == DateBucket.today;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Text(
        label,
        style: theme.textTheme.labelLarge?.copyWith(
          color: isToday
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface.withValues(alpha: 0.45),
          fontWeight: isToday ? FontWeight.w700 : FontWeight.w600,
        ),
      ),
    );
  }
}
