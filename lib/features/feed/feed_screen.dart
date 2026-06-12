import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/current_affair.dart';
import '../../data/repository/content_repo.dart';

final feedProvider = FutureProvider<List<CurrentAffair>>((ref) async {
  final repo = ref.watch(contentRepositoryProvider);
  return repo.loadEntries();
});

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(feedProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('लोकसेवा प्राइम'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.bookmark_border), onPressed: () {}),
        ],
      ),
      body: feedAsync.when(
        data: (entries) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            return _EntryCard(entry: entries[index]);
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
                'सामग्री लोड गर्न सकिएन\n$error',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EntryCard extends StatelessWidget {
  final CurrentAffair entry;
  const _EntryCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    final chipStyle = textTheme.labelSmall?.copyWith(
      color: colors.onPrimaryContainer,
    );
    final subtitleStyle = textTheme.bodyMedium?.copyWith(
      color: colors.onSurface.withValues(alpha: 0.6),
    );
    final metadataStyle = textTheme.labelMedium?.copyWith(
      color: colors.onSurfaceVariant,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(entry.category, style: chipStyle),
              ),
              const SizedBox(height: 10),
              Text(entry.titleNp, style: textTheme.headlineMedium),
              const SizedBox(height: 6),
              Text(entry.titleEn, style: subtitleStyle),
              const SizedBox(height: 10),
              Text(
                entry.summaryNp,
                style: textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: colors.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(entry.date, style: metadataStyle),
                  const Spacer(),
                  Icon(Icons.source, size: 14, color: colors.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(entry.source, style: metadataStyle),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
