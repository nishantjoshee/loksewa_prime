import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text(UiStrings.detailNp),
        actions: [
          Semantics(
            label: isBookmarked
                ? UiStrings.removeBookmarkNp
                : UiStrings.bookmarksNp,
            button: true,
            child: IconButton(
              icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
              onPressed: () => bookmarksNotifier.toggle(entryId),
            ),
          ),
          Semantics(
            label: UiStrings.shareNp,
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
            return const Center(child: Text(UiStrings.noResultsNp));
          }
          return _DetailContent(entry: entry, isBookmarked: isBookmarked);
        },
        loading: () => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(UiStrings.loadingNp),
            ],
          ),
        ),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 16),
              Text(
                '${UiStrings.loadErrorNp}\n$error',
                textAlign: TextAlign.center,
              ),
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

  const _DetailContent({required this.entry, required this.isBookmarked});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

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
                label: '${UiStrings.tagsNp}: ${entry.category}',
                child: Text(
                  entry.category,
                  style: textTheme.labelSmall?.copyWith(
                    color: colors.onPrimaryContainer,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(entry.titleNp, style: textTheme.headlineLarge),
            const SizedBox(height: 8),
            Text(
              entry.titleEn,
              style: textTheme.headlineMedium?.copyWith(
                color: colors.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 20),
            Text(entry.summaryNp, style: textTheme.bodyLarge),
            const SizedBox(height: 16),
            Text(entry.summaryEn, style: textTheme.bodyMedium),
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
                  '${UiStrings.dateNp}: ${entry.date}',
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
                  '${UiStrings.sourceNp}: ${entry.source}',
                  style: textTheme.labelMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Semantics(
              label: '${UiStrings.tagsNp}: ${entry.tags.join(', ')}',
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
