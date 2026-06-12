import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/language_provider.dart';
import '../feed_providers.dart';
import '../read_providers.dart';
import 'read_filter_chips.dart';

class GreetingHeader extends ConsumerWidget {
  const GreetingHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(uiStringsProvider);
    final feedAsync = ref.watch(feedProvider);
    final readEntries = ref.watch(readEntriesProvider);
    final readFilter = ref.watch(readFilterProvider);
    final theme = Theme.of(context);
    final now = DateTime.now();
    final hour = now.hour;

    final greeting = hour < 12
        ? strings.greetingMorning
        : hour < 17
        ? strings.greetingAfternoon
        : strings.greetingEvening;

    final icon = hour < 12
        ? Icons.wb_sunny_outlined
        : hour < 17
        ? Icons.wb_cloudy_outlined
        : Icons.nights_stay_outlined;

    final todayCounts = feedAsync.maybeWhen(
      data: (entries) {
        final todayStr =
            '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
        final todayEntries = entries.where((e) => e.date == todayStr);
        final unread = todayEntries
            .where((e) => !readEntries.contains(e.id))
            .length;
        final rd = todayEntries.where((e) => readEntries.contains(e.id)).length;
        return (unread: unread, read: rd);
      },
      orElse: () => (unread: 0, read: 0),
    );

    void setFilter(ReadFilter f) {
      final current = ref.read(readFilterProvider);
      ref.read(readFilterProvider.notifier).state = current == f
          ? ReadFilter.all
          : f;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 22, color: theme.colorScheme.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  greeting,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            strings.greetingSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _pill(
                label:
                    '${todayCounts.unread > 99 ? '99+' : todayCounts.unread} Unread',
                selected: readFilter == ReadFilter.unread,
                color: theme.colorScheme.error,
                onTap: () => setFilter(ReadFilter.unread),
              ),
              const SizedBox(width: 8),
              _pill(
                label:
                    '${todayCounts.read > 99 ? '99+' : todayCounts.read} Read',
                selected: readFilter == ReadFilter.read,
                color: Colors.green,
                onTap: () => setFilter(ReadFilter.read),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pill({
    required String label,
    required bool selected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: selected
              ? color.withValues(alpha: 0.15)
              : color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: selected ? Border.all(color: color, width: 1.5) : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
