import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/language_provider.dart';
import '../../core/widgets/entry_card.dart';
import '../../data/models/current_affair.dart';
import '../bookmarks/bookmarks_providers.dart';
import 'feed_providers.dart';
import 'read_providers.dart';
import 'widgets/category_chips.dart';
import 'widgets/date_section_header.dart';
import 'widgets/greeting_header.dart';
import 'widgets/read_filter_chips.dart';

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
    final readFilter = ref.watch(readFilterProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const GreetingHeader(),
            const CategoryChips(),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: KeyedSubtree(
                  key: ValueKey('$selectedCategory-$readFilter'),
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
                                    readFilter != ReadFilter.read &&
                                    unread.isNotEmpty;
                                return [
                                  if (showUnread) ...[
                                    SliverToBoxAdapter(
                                      child: DateSectionHeader(group: group),
                                    ),
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
                                          onTap: () => context.push(
                                            '/detail/${entry.id}',
                                          ),
                                          onToggleRead: () {
                                            final notifier = ref.read(
                                              readEntriesProvider.notifier,
                                            );
                                            notifier.markRead(entry.id);
                                            ScaffoldMessenger.of(context)
                                              ..hideCurrentSnackBar()
                                              ..showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    language == 'np'
                                                        ? 'पढिसकिएको चिन्ह लगाइयो'
                                                        : 'Marked as read',
                                                  ),
                                                  duration: const Duration(
                                                    milliseconds: 1500,
                                                  ),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  width: 240,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                ),
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
                              readFilter != ReadFilter.unread) ...[
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  20,
                                  16,
                                  20,
                                  8,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.check_circle_outline,
                                      size: 16,
                                      color: Color(0xFF9E9E9E),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      language == 'np'
                                          ? 'पढिसकिएको (${allReadEntries.length})'
                                          : 'Read (${allReadEntries.length})',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                            color: const Color(0xFF9E9E9E),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
                                      context.push('/detail/${entry.id}'),
                                  onToggleRead: () {
                                    final notifier = ref.read(
                                      readEntriesProvider.notifier,
                                    );
                                    notifier.unmarkRead(entry.id);
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            language == 'np'
                                                ? 'नपढिएको चिन्ह लगाइयो'
                                                : 'Marked as unread',
                                          ),
                                          duration: const Duration(
                                            milliseconds: 1500,
                                          ),
                                          behavior: SnackBarBehavior.floating,
                                          width: 240,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
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
