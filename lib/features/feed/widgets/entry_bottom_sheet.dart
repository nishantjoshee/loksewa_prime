import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/providers/language_provider.dart';
import '../../../../data/models/current_affair.dart';
import '../../bookmarks/bookmarks_providers.dart';
import '../read_providers.dart';
import 'read_snackbar.dart';

void showEntryBottomSheet(BuildContext context, CurrentAffair entry) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _EntrySheetContent(entry: entry, parentContext: context),
  );
}

class _EntrySheetContent extends ConsumerWidget {
  final CurrentAffair entry;
  final BuildContext parentContext;

  const _EntrySheetContent({required this.entry, required this.parentContext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final strings = ref.watch(uiStringsProvider);
    final language = ref.watch(languageProvider);
    final isNp = language == 'np';
    final isBookmarked = ref.watch(bookmarksProvider).contains(entry.id);
    final isRead = ref.watch(readEntriesProvider).contains(entry.id);
    final bookmarksNotifier = ref.watch(bookmarksProvider.notifier);
    final readNotifier = ref.watch(readEntriesProvider.notifier);

    final title = isNp ? entry.titleNp : entry.titleEn;
    final secondaryTitle = isNp ? entry.titleEn : entry.titleNp;
    final summary = isNp ? entry.summaryNp : entry.summaryEn;
    final secondarySummary = isNp ? entry.summaryEn : entry.summaryNp;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollController) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 4),
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isNp ? entry.category : entry.categoryEn,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          isRead ? Icons.check_circle : Icons.circle_outlined,
                          size: 22,
                        ),
                        color: isRead
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface.withValues(
                                alpha: 0.3,
                              ),
                        onPressed: () {
                          if (isRead) {
                            readNotifier.unmarkRead(entry.id);
                          } else {
                            readNotifier.markRead(entry.id);
                          }
                          showReadSnackBar(
                            context: parentContext,
                            wasRead: isRead,
                            entryId: entry.id,
                            notifier: readNotifier,
                            isNp: isNp,
                          );
                          Navigator.pop(context);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          size: 22,
                        ),
                        color: isBookmarked
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface.withValues(
                                alpha: 0.3,
                              ),
                        onPressed: () => bookmarksNotifier.toggle(entry.id),
                      ),
                      IconButton(
                        icon: const Icon(Icons.share, size: 22),
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.3,
                        ),
                        onPressed: () => Share.share(
                          '${entry.titleNp}\n${entry.titleEn}\n\n${entry.summaryNp}',
                          subject: entry.titleNp,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    secondaryTitle,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    summary,
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.7),
                  ),
                  if (secondarySummary.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Text(
                      secondarySummary,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.55,
                        ),
                        height: 1.65,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${strings.date}: ${entry.date}',
                        style: theme.textTheme.labelMedium,
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.source_outlined,
                        size: 14,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${strings.source}: ${entry.source}',
                        style: theme.textTheme.labelMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: entry.tags
                        .map(
                          (tag) => Chip(
                            label: Text(tag, style: theme.textTheme.labelSmall),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
