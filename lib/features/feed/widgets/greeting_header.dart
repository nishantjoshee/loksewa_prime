import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/language_provider.dart';
import '../feed_providers.dart';
import '../read_providers.dart';
import 'filter_bar.dart';

class GreetingHeader extends ConsumerWidget {
  const GreetingHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(uiStringsProvider);
    final feedAsync = ref.watch(filteredFeedProvider);
    final readEntries = ref.watch(readEntriesProvider);
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

    final timeFilter = ref.watch(timeFilterProvider);
    final isNp = ref.watch(languageProvider) == 'np';

    final todayStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final weekAgo = now.subtract(const Duration(days: 7));
    final weekAgoStr =
        '${weekAgo.year}-${weekAgo.month.toString().padLeft(2, '0')}-${weekAgo.day.toString().padLeft(2, '0')}';
    final monthStart = '${now.year}-${now.month.toString().padLeft(2, '0')}';

    final counts = feedAsync.maybeWhen(
      data: (entries) {
        final filtered = switch (timeFilter) {
          TimeFilter.today => entries.where((e) => e.date == todayStr),
          TimeFilter.week => entries.where(
            (e) => e.date.compareTo(weekAgoStr) >= 0,
          ),
          TimeFilter.month => entries.where(
            (e) => e.date.startsWith(monthStart),
          ),
          TimeFilter.all => entries,
        };
        final unread = filtered
            .where((e) => !readEntries.contains(e.id))
            .length;
        final rd = filtered.where((e) => readEntries.contains(e.id)).length;
        return (unread: unread, read: rd);
      },
      orElse: () => (unread: 0, read: 0),
    );

    final total = counts.unread + counts.read;
    final progress = total > 0 ? counts.read / total : 0.0;

    final periodLabel = switch (timeFilter) {
      TimeFilter.today => isNp ? 'आज' : 'today',
      TimeFilter.week => isNp ? 'यो हप्ता' : 'this week',
      TimeFilter.month => isNp ? 'यो महिना' : 'this month',
      TimeFilter.all => isNp ? 'जम्मा' : 'total',
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 2),
      child: Center(
        child: Column(
          children: [
            Icon(icon, size: 24, color: theme.colorScheme.primary),
            const SizedBox(height: 4),
            Text(
              greeting,
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              strings.greetingSubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            if (total > 0) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.outline),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 3.5,
                        color: theme.colorScheme.primary,
                        backgroundColor: theme.colorScheme.primary.withValues(
                          alpha: 0.1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      isNp
                          ? '${counts.read}/$total $periodLabel पढियो'
                          : '${counts.read}/$total read $periodLabel',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
