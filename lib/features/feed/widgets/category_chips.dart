import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants.dart';
import '../../../core/providers/language_provider.dart';
import '../feed_providers.dart';

class CategoryChips extends ConsumerWidget {
  const CategoryChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedCategoryProvider);
    final language = ref.watch(languageProvider);
    final strings = ref.watch(uiStringsProvider);
    final categories = language == 'np'
        ? AppConstants.categoriesNp
        : AppConstants.categoriesEn;

    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          FilterChip(
            label: Text(strings.all),
            selected: selected == null,
            onSelected: (_) {
              ref.read(selectedCategoryProvider.notifier).state = null;
            },
          ),
          const SizedBox(width: 8),
          ...categories.map(
            (cat) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(cat),
                selected: selected == cat,
                onSelected: (_) {
                  ref.read(selectedCategoryProvider.notifier).state =
                      selected == cat ? null : cat;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
