import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants.dart';
import '../../../core/providers/language_provider.dart';
import '../feed_providers.dart';

class CategoryChips extends ConsumerStatefulWidget {
  const CategoryChips({super.key});

  @override
  ConsumerState<CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends ConsumerState<CategoryChips> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToIndex(int index) {
    if (!_scrollController.hasClients) return;
    const chipWidth = 100.0;
    const gap = 6.0;
    const padding = 20.0;
    final target = padding + (index * (chipWidth + gap)) - 40;
    final clamped = target.clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    _scrollController.animateTo(
      clamped,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(selectedCategoryProvider);
    final language = ref.watch(languageProvider);
    final strings = ref.watch(uiStringsProvider);
    final categories = language == 'np'
        ? AppConstants.categoriesNp
        : AppConstants.categoriesEn;

    ref.listen(selectedCategoryProvider, (_, next) {
      if (next == null) {
        _scrollToIndex(0);
      } else {
        final idx = categories.indexOf(next);
        if (idx != -1) _scrollToIndex(idx + 1); // +1 for the "All" chip
      }
    });

    return SizedBox(
      height: 40,
      child: ListView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: FilterChip(
              label: Text(strings.all, style: const TextStyle(fontSize: 12)),
              selected: selected == null,
              onSelected: (_) {
                ref.read(selectedCategoryProvider.notifier).state = null;
              },
              visualDensity: VisualDensity.compact,
            ),
          ),
          ...categories.map((cat) {
            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: FilterChip(
                label: Text(cat, style: const TextStyle(fontSize: 12)),
                selected: selected == cat,
                onSelected: (_) {
                  ref.read(selectedCategoryProvider.notifier).state =
                      selected == cat ? null : cat;
                },
                visualDensity: VisualDensity.compact,
              ),
            );
          }),
        ],
      ),
    );
  }
}
