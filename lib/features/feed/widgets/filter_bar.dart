import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants.dart';
import '../../../core/providers/language_provider.dart';
import '../feed_providers.dart';
import '../read_providers.dart';

enum TimeFilter { today, week, month, all }

enum StatusFilter { all, unread, read }

final timeFilterProvider = StateProvider<TimeFilter>((ref) => TimeFilter.today);
final statusFilterProvider = StateProvider<StatusFilter>(
  (ref) => StatusFilter.all,
);

class FilterBar extends ConsumerStatefulWidget {
  const FilterBar({super.key});

  @override
  ConsumerState<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends ConsumerState<FilterBar> {
  final _scrollController = ScrollController();
  String? _previousSelection;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToIndex(int index) {
    if (!_scrollController.hasClients) return;
    const chipWidth = 90.0;
    const chipMargin = 6.0;
    final targetOffset = index * (chipWidth + chipMargin);
    final maxExtent = _scrollController.position.maxScrollExtent;
    final clampedOffset = targetOffset.clamp(0.0, maxExtent);
    _scrollController.animateTo(
      clampedOffset,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final timeFilter = ref.watch(timeFilterProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final language = ref.watch(languageProvider);
    final theme = Theme.of(context);

    final isNp = language == 'np';
    final categories = isNp
        ? AppConstants.categoriesNp
        : AppConstants.categoriesEn;

    final now = DateTime.now();
    final todayStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final weekAgo = now.subtract(const Duration(days: 7));
    final weekAgoStr =
        '${weekAgo.year}-${weekAgo.month.toString().padLeft(2, '0')}-${weekAgo.day.toString().padLeft(2, '0')}';
    final monthStart = '${now.year}-${now.month.toString().padLeft(2, '0')}';

    final statusFilter = ref.watch(statusFilterProvider);
    final readEntries = ref.watch(readEntriesProvider);
    final allFeedAsync = ref.watch(feedProvider);

    final unreadCount = allFeedAsync.maybeWhen(
      data: (entries) {
        final filtered = switch (timeFilter) {
          TimeFilter.today => entries.where((e) => e.date == todayStr),
          TimeFilter.week => entries.where(
            (e) => e.date.compareTo(weekAgoStr) >= 0,
          ),
          TimeFilter.month => entries.where(
            (e) => e.date.startsWith(monthStart),
          ),
          TimeFilter.all => entries,
        };
        return filtered.where((e) => !readEntries.contains(e.id)).length;
      },
      orElse: () => 0,
    );

    final categoryCounts = allFeedAsync.maybeWhen(
      data: (entries) {
        final timeFiltered = switch (timeFilter) {
          TimeFilter.today => entries.where((e) => e.date == todayStr),
          TimeFilter.week => entries.where(
            (e) => e.date.compareTo(weekAgoStr) >= 0,
          ),
          TimeFilter.month => entries.where(
            (e) => e.date.startsWith(monthStart),
          ),
          TimeFilter.all => entries,
        };
        final counts = <String, int>{};
        for (final e in timeFiltered) {
          final cat = isNp ? e.category : e.categoryEn;
          counts[cat] = (counts[cat] ?? 0) + 1;
        }
        return counts;
      },
      orElse: () => <String, int>{},
    );

    Widget buildDropdown<T>({
      required String label,
      required T current,
      required List<T> values,
      required String Function(T) labelFor,
      required void Function(T) onSelected,
      IconData? icon,
    }) {
      return PopupMenuButton<T>(
        offset: const Offset(0, 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onSelected: onSelected,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 14,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                const SizedBox(width: 5),
              ],
              Flexible(
                child: Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_drop_down,
                size: 16,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
        itemBuilder: (_) => values.map((v) {
          final selected = v == current;
          return PopupMenuItem<T>(
            value: v,
            child: Row(
              children: [
                if (selected)
                  const Icon(Icons.check, size: 16, color: Color(0xFF52C41A))
                else
                  const SizedBox(width: 16),
                const SizedBox(width: 8),
                Text(
                  labelFor(v),
                  style: TextStyle(
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    }

    String timeLabel(TimeFilter f) => switch (f) {
      TimeFilter.today => isNp ? 'आज' : 'Today',
      TimeFilter.week => isNp ? 'यो हप्ता' : 'This Week',
      TimeFilter.month => isNp ? 'यो महिना' : 'This Month',
      TimeFilter.all => isNp ? 'सबै' : 'All',
    };

    final allLabel = isNp ? 'सबै' : 'All';
    final totalAll = categoryCounts.values.fold(0, (a, b) => a + b);

    final selectedIndex = selectedCategory == null
        ? 0
        : 1 + categories.indexOf(selectedCategory);

    if (_previousSelection != selectedCategory) {
      _previousSelection = selectedCategory;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (selectedIndex >= 0) _scrollToIndex(selectedIndex);
      });
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              buildDropdown<TimeFilter>(
                label: timeLabel(timeFilter),
                current: timeFilter,
                values: TimeFilter.values,
                labelFor: timeLabel,
                onSelected: (f) =>
                    ref.read(timeFilterProvider.notifier).state = f,
                icon: Icons.calendar_today,
              ),
              const SizedBox(width: 6),
              _StatusChip(
                status: statusFilter,
                unreadCount: unreadCount,
                isNp: isNp,
                onTap: () {
                  final next = switch (statusFilter) {
                    StatusFilter.all => StatusFilter.unread,
                    StatusFilter.unread => StatusFilter.read,
                    StatusFilter.read => StatusFilter.all,
                  };
                  ref.read(statusFilterProvider.notifier).state = next;
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 28,
            child: ListView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              children: [
                _CategoryChip(
                  label: '$allLabel ($totalAll)',
                  selected: selectedCategory == null,
                  onTap: () =>
                      ref.read(selectedCategoryProvider.notifier).state = null,
                ),
                for (final cat in categories)
                  _CategoryChip(
                    label: '$cat (${categoryCounts[cat] ?? 0})',
                    selected: selectedCategory == cat,
                    onTap: () {
                      ref.read(selectedCategoryProvider.notifier).state =
                          selectedCategory == cat ? null : cat;
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Material(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: selected ? colors.primary : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: selected ? colors.primary : colors.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final StatusFilter status;
  final int unreadCount;
  final bool isNp;
  final VoidCallback onTap;

  const _StatusChip({
    required this.status,
    required this.unreadCount,
    required this.isNp,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final label = switch (status) {
      StatusFilter.all => isNp ? 'सबै देखाउनुहोस्' : 'Show all',
      StatusFilter.unread =>
        isNp ? 'नपढिएको ($unreadCount)' : 'Unread ($unreadCount)',
      StatusFilter.read => isNp ? 'पढिएको मात्र' : 'Read only',
    };

    final active = status != StatusFilter.all;

    return Material(
      color: active
          ? colors.primary.withValues(alpha: 0.1)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: active
                  ? colors.primary
                  : colors.outline.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                active ? Icons.filter_list : Icons.filter_list_outlined,
                size: 14,
                color: active
                    ? colors.primary
                    : colors.onSurface.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: active ? colors.primary : colors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
