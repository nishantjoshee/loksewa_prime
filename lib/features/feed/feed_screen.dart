import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/language_provider.dart';
import '../../core/widgets/entry_card.dart';
import '../bookmarks/bookmarks_providers.dart';
import 'feed_providers.dart';
import 'widgets/category_chips.dart';
import 'widgets/date_section_header.dart';
import 'widgets/greeting_header.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupedAsync = ref.watch(groupedFeedProvider);
    final bookmarks = ref.watch(bookmarksProvider);
    final language = ref.watch(languageProvider);
    final strings = ref.watch(uiStringsProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
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
                  key: ValueKey(selectedCategory),
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
                      return CustomScrollView(
                        slivers: [
                          ...groups
                              .map(
                                (group) => [
                                  SliverToBoxAdapter(
                                    child: DateSectionHeader(group: group),
                                  ),
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate((
                                      context,
                                      index,
                                    ) {
                                      final entry = group.entries[index];
                                      return EntryCard(
                                        entry: entry,
                                        isBookmarked: bookmarks.contains(
                                          entry.id,
                                        ),
                                        language: language,
                                        onTap: () =>
                                            context.push('/detail/${entry.id}'),
                                      );
                                    }, childCount: group.entries.length),
                                  ),
                                ],
                              )
                              .expand((g) => g),
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
