import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/ui_strings.dart';
import '../../core/widgets/entry_card.dart';
import '../bookmarks/bookmarks_providers.dart';
import 'feed_providers.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(feedProvider);
    final bookmarks = ref.watch(bookmarksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(UiStrings.appTitleNp),
        actions: [
          Semantics(
            label: UiStrings.searchNp,
            button: true,
            child: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => context.push('/search'),
            ),
          ),
          Semantics(
            label: UiStrings.bookmarksNp,
            button: true,
            child: IconButton(
              icon: const Icon(Icons.bookmark_border),
              onPressed: () => context.push('/bookmarks'),
            ),
          ),
        ],
      ),
      body: feedAsync.when(
        data: (entries) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            return EntryCard(
              entry: entry,
              isBookmarked: bookmarks.contains(entry.id),
              onTap: () => context.push('/detail/${entry.id}'),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
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
