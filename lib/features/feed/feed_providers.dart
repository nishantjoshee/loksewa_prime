import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/current_affair.dart';
import '../../data/repository/content_repo.dart';
import 'widgets/filter_bar.dart';

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
    return entries
        .where((e) => e.category == category || e.categoryEn == category)
        .toList();
  });
});

enum DateBucket { today, yesterday, thisWeek, older }

class DateGroup {
  final DateBucket bucket;
  final String label;
  final List<CurrentAffair> entries;

  const DateGroup({
    required this.bucket,
    required this.label,
    required this.entries,
  });
}

final groupedFeedProvider = Provider<AsyncValue<List<DateGroup>>>((ref) {
  final feedAsync = ref.watch(filteredFeedProvider);
  final timeFilter = ref.watch(timeFilterProvider);
  return feedAsync.whenData((entries) {
    if (entries.isEmpty) return [];

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final weekAgo = today.subtract(const Duration(days: 7));
    final monthStart =
        '${today.year}-${today.month.toString().padLeft(2, '0')}';

    // Apply time filter
    entries = switch (timeFilter) {
      TimeFilter.today =>
        entries
            .where(
              (e) =>
                  e.date ==
                  '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}',
            )
            .toList(),
      TimeFilter.week =>
        entries
            .where(
              (e) =>
                  e.date.compareTo(
                    '${weekAgo.year}-${weekAgo.month.toString().padLeft(2, '0')}-${weekAgo.day.toString().padLeft(2, '0')}',
                  ) >=
                  0,
            )
            .toList(),
      TimeFilter.month =>
        entries.where((e) => e.date.startsWith(monthStart)).toList(),
      TimeFilter.all => entries,
    };
    if (entries.isEmpty) return [];

    final todayStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final yesterdayStr =
        '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';
    final weekAgoStr =
        '${weekAgo.year}-${weekAgo.month.toString().padLeft(2, '0')}-${weekAgo.day.toString().padLeft(2, '0')}';

    final todayList = <CurrentAffair>[];
    final yesterdayList = <CurrentAffair>[];
    final weekList = <CurrentAffair>[];
    final olderList = <CurrentAffair>[];

    for (final entry in entries) {
      if (entry.date == todayStr) {
        todayList.add(entry);
      } else if (entry.date == yesterdayStr) {
        yesterdayList.add(entry);
      } else if (entry.date.compareTo(weekAgoStr) >= 0) {
        weekList.add(entry);
      } else {
        olderList.add(entry);
      }
    }

    final groups = <DateGroup>[];
    if (todayList.isNotEmpty) {
      groups.add(
        DateGroup(bucket: DateBucket.today, label: 'today', entries: todayList),
      );
    }
    if (yesterdayList.isNotEmpty) {
      groups.add(
        DateGroup(
          bucket: DateBucket.yesterday,
          label: 'yesterday',
          entries: yesterdayList,
        ),
      );
    }
    if (weekList.isNotEmpty) {
      groups.add(
        DateGroup(
          bucket: DateBucket.thisWeek,
          label: 'thisWeek',
          entries: weekList,
        ),
      );
    }
    if (olderList.isNotEmpty) {
      groups.add(
        DateGroup(bucket: DateBucket.older, label: 'older', entries: olderList),
      );
    }

    return groups;
  });
});
