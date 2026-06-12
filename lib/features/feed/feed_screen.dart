import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/language_provider.dart';
import '../../core/widgets/entry_card.dart';
import '../../data/models/current_affair.dart';
import '../bookmarks/bookmarks_providers.dart';
import 'feed_providers.dart';
import 'read_providers.dart';
import 'widgets/entry_bottom_sheet.dart';
import 'widgets/filter_bar.dart';
import 'widgets/greeting_header.dart';
import 'widgets/read_snackbar.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupedAsync = ref.watch(groupedFeedProvider);
    final bookmarks = ref.watch(bookmarksProvider);
    final readEntries = ref.watch(readEntriesProvider);
    final language = ref.watch(languageProvider);
    final strings = ref.watch(uiStringsProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final statusFilter = ref.watch(statusFilterProvider);
    final timeFilter = ref.watch(timeFilterProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const GreetingHeader(),
            const FilterBar(),
            const SizedBox(height: 4),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: KeyedSubtree(
                  key: ValueKey('$selectedCategory-$statusFilter-$timeFilter'),
                  child: groupedAsync.when(
                    data: (groups) {
                      if (groups.isEmpty) {
                        return Center(
                          child: Text(
                            strings.noResults,
                            style: theme.textTheme.bodyLarge,
                          ),
                        );
                      }
                      final allReadEntries = <CurrentAffair>[];

                      return CustomScrollView(
                        slivers: [
                          ...groups
                              .map((group) {
                                final unread = group.entries
                                    .where((e) => !readEntries.contains(e.id))
                                    .toList();
                                final read = group.entries
                                    .where((e) => readEntries.contains(e.id))
                                    .toList();
                                allReadEntries.addAll(read);
                                final showUnread =
                                    statusFilter != StatusFilter.read &&
                                    unread.isNotEmpty;
                                return [
                                  if (showUnread) ...[
                                    SliverList(
                                      delegate: SliverChildBuilderDelegate((
                                        context,
                                        index,
                                      ) {
                                        final entry = unread[index];
                                        return EntryCard(
                                          entry: entry,
                                          isBookmarked: bookmarks.contains(
                                            entry.id,
                                          ),
                                          isRead: false,
                                          language: language,
                                          onTap: () => showEntryBottomSheet(
                                            context,
                                            entry,
                                          ),
                                          onToggleRead: () {
                                            final notifier = ref.read(
                                              readEntriesProvider.notifier,
                                            );
                                            notifier.markRead(entry.id);
                                            showReadSnackBar(
                                              context: context,
                                              wasRead: false,
                                              entryId: entry.id,
                                              notifier: notifier,
                                              isNp: language == 'np',
                                            );
                                          },
                                          onToggleBookmark: () {
                                            ref
                                                .read(
                                                  bookmarksProvider.notifier,
                                                )
                                                .toggle(entry.id);
                                          },
                                        );
                                      }, childCount: unread.length),
                                    ),
                                  ],
                                ];
                              })
                              .expand((g) => g),
                          if (allReadEntries.isNotEmpty &&
                              statusFilter != StatusFilter.unread) ...[
                            SliverList(
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                final entry = allReadEntries[index];
                                return EntryCard(
                                  entry: entry,
                                  isBookmarked: bookmarks.contains(entry.id),
                                  isRead: true,
                                  language: language,
                                  onTap: () =>
                                      showEntryBottomSheet(context, entry),
                                  onToggleRead: () {
                                    final notifier = ref.read(
                                      readEntriesProvider.notifier,
                                    );
                                    notifier.unmarkRead(entry.id);
                                    showReadSnackBar(
                                      context: context,
                                      wasRead: true,
                                      entryId: entry.id,
                                      notifier: notifier,
                                      isNp: language == 'np',
                                    );
                                  },
                                  onToggleBookmark: () {
                                    ref
                                        .read(bookmarksProvider.notifier)
                                        .toggle(entry.id);
                                  },
                                );
                              }, childCount: allReadEntries.length),
                            ),
                          ],
                          const SliverPadding(
                            padding: EdgeInsets.only(bottom: 24),
                          ),
                        ],
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, _) => Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline, size: 48),
                          const SizedBox(height: 16),
                          Text(
                            '${strings.loadError}\n$error',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
