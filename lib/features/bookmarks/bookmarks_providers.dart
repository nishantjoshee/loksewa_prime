import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants.dart';
import '../../core/error_reporter.dart';
import '../../data/models/current_affair.dart';
import '../feed/feed_providers.dart';

final bookmarksProvider = StateNotifierProvider<BookmarksNotifier, Set<String>>(
  (ref) {
    return BookmarksNotifier();
  },
);

final bookmarkedEntriesProvider = Provider<AsyncValue<List<CurrentAffair>>>((
  ref,
) {
  final bookmarkIds = ref.watch(bookmarksProvider);
  final feedAsync = ref.watch(feedProvider);

  return feedAsync.whenData(
    (entries) => entries.where((e) => bookmarkIds.contains(e.id)).toList(),
  );
});

class BookmarksNotifier extends StateNotifier<Set<String>> {
  BookmarksNotifier() : super({}) {
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ids = prefs.getStringList(AppConstants.bookmarksKey) ?? [];
      state = ids.toSet();
    } catch (e, stack) {
      ErrorReporter.report(e, stack: stack);
    }
  }

  Future<void> toggle(String id) async {
    final updated = {...state};
    if (updated.contains(id)) {
      updated.remove(id);
    } else {
      updated.add(id);
    }
    state = updated;
    await _persist();
  }

  Future<void> remove(String id) async {
    final updated = {...state};
    updated.remove(id);
    state = updated;
    await _persist();
  }

  bool isBookmarked(String id) => state.contains(id);

  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(AppConstants.bookmarksKey, state.toList());
    } catch (e, stack) {
      ErrorReporter.report(e, stack: stack);
    }
  }
}
