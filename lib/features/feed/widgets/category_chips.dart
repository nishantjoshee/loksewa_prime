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

  void _scrollToSelected(String? selected, List<String> categories) {
    if (selected == null) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
      return;
    }

    final index = categories.indexOf(selected);
    if (index == -1) return;

    // Approximate offset: "All" chip + gap + previous chips
    const allChipWidth = 70.0;
    const chipWidth = 100.0;
    const gap = 6.0;
    final offset = allChipWidth + gap + (index * (chipWidth + gap)) - 40;

    final target = offset.clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );

    _scrollController.animateTo(
      target,
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

    // Auto-scroll when selection changes
    ref.listen(selectedCategoryProvider, (_, next) {
      _scrollToSelected(next, categories);
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
