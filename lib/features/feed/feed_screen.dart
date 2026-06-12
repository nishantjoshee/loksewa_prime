import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/language_provider.dart';
import '../../core/widgets/entry_card.dart';
import '../bookmarks/bookmarks_providers.dart';
import 'feed_providers.dart';
import 'widgets/category_chips.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(filteredFeedProvider);
    final bookmarks = ref.watch(bookmarksProvider);
    final language = ref.watch(languageProvider);
    final strings = ref.watch(uiStringsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(strings.appTitle)),
      body: feedAsync.when(
        data: (entries) => Column(
          children: [
            const CategoryChips(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  return EntryCard(
                    entry: entry,
                    isBookmarked: bookmarks.contains(entry.id),
                    language: language,
                    onTap: () => context.push('/detail/${entry.id}'),
                  );
                },
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
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
