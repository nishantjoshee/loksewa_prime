import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/providers/language_provider.dart';
import '../../core/ui_strings.dart';
import '../../data/models/current_affair.dart';
import '../bookmarks/bookmarks_providers.dart';
import 'detail_providers.dart';

class DetailScreen extends ConsumerWidget {
  final String entryId;
  const DetailScreen({super.key, required this.entryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(detailProvider(entryId));
    final bookmarksNotifier = ref.watch(bookmarksProvider.notifier);
    final isBookmarked = ref.watch(bookmarksProvider).contains(entryId);
    final strings = ref.watch(uiStringsProvider);
    final language = ref.watch(languageProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.detail),
        actions: [
          Semantics(
            label: isBookmarked ? strings.removeBookmark : strings.bookmarks,
            button: true,
            child: IconButton(
              icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
              onPressed: () => bookmarksNotifier.toggle(entryId),
            ),
          ),
          Semantics(
            label: strings.share,
            button: true,
            child: IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                detailAsync.whenData((entry) {
                  if (entry != null) {
                    Share.share(
                      '${entry.titleNp}\n${entry.titleEn}\n\n${entry.summaryNp}',
                      subject: entry.titleNp,
                    );
                  }
                });
              },
            ),
          ),
        ],
      ),
      body: detailAsync.when(
        data: (entry) {
          if (entry == null) {
            return Center(child: Text(strings.noResults));
          }
          return _DetailContent(
            entry: entry,
            isBookmarked: isBookmarked,
            language: language,
            strings: strings,
          );
        },
        loading: () => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(strings.loading),
            ],
          ),
        ),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 16),
              Text('${strings.loadError}\n$error', textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  final CurrentAffair entry;
  final bool isBookmarked;
  final String language;
  final UiStringsData strings;

  const _DetailContent({
    required this.entry,
    required this.isBookmarked,
    required this.language,
    required this.strings,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    final isNp = language == 'np';
    final primaryTitle = isNp ? entry.titleNp : entry.titleEn;
    final secondaryTitle = isNp ? entry.titleEn : entry.titleNp;
    final primarySummary = isNp ? entry.summaryNp : entry.summaryEn;
    final secondarySummary = isNp ? entry.summaryEn : entry.summaryNp;

    return Semantics(
      label: '${entry.titleNp}. ${entry.titleEn}',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Semantics(
                label: '${strings.tags}: ${entry.category}',
                child: Text(
                  entry.category,
                  style: textTheme.labelSmall?.copyWith(
                    color: colors.onPrimaryContainer,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(primaryTitle, style: textTheme.headlineLarge),
            const SizedBox(height: 8),
            Text(
              secondaryTitle,
              style: textTheme.headlineMedium?.copyWith(
                color: colors.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 20),
            Text(primarySummary, style: textTheme.bodyLarge),
            const SizedBox(height: 16),
            Text(
              secondarySummary,
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: colors.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  '${strings.date}: ${entry.date}',
                  style: textTheme.labelMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.source, size: 16, color: colors.onSurfaceVariant),
                const SizedBox(width: 6),
                Text(
                  '${strings.source}: ${entry.source}',
                  style: textTheme.labelMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Semantics(
              label: '${strings.tags}: ${entry.tags.join(', ')}',
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: entry.tags.map((tag) {
                  return Chip(
                    label: Text(tag, style: textTheme.labelSmall),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
