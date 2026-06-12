import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/current_affair.dart';
import '../../data/repository/content_repo.dart';

final feedProvider = FutureProvider<List<CurrentAffair>>((ref) async {
  final repo = ref.watch(contentRepositoryProvider);
  final result = await repo.loadEntries();
  return result.fold(
    onOk: (entries) => entries,
    onErr: (error, _) => throw error,
  );
});

final selectedCategoryProvider = StateProvider<String?>((ref) => null);

final filteredFeedProvider = Provider<AsyncValue<List<CurrentAffair>>>((ref) {
  final feedAsync = ref.watch(feedProvider);
  final category = ref.watch(selectedCategoryProvider);

  return feedAsync.whenData((entries) {
    if (category == null) return entries;
    return entries.where((e) => e.category == category).toList();
  });
});
