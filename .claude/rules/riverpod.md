---
paths:
  - "lib/**/*.dart"
  - "lib/**/*_providers.dart"
---

# Riverpod State Management Patterns

## Provider types we use
- `FutureProvider` — for async data loading (feed, search results, detail)
- `FutureProvider.family` — parameterized async loading (detail by entry ID)
- `StateProvider` — for simple mutable state (selected category, search query)
- `StateNotifierProvider` — for complex state with actions (bookmarks, settings)
- `Provider` — for repository/service injection

## Rules
1. **Always prefer `ConsumerWidget` over `Consumer` widget** — for simple read-only state
2. **Use `ConsumerStatefulWidget`** when you need TextEditingController, Timer, or local state
3. **Use `ref.watch()` in build methods** for reactive updates
4. **Use `ref.read()` in callbacks** (onTap, onPressed) to avoid unnecessary rebuilds
5. **Keep providers in a separate file**: `<feature>_providers.dart`
6. **`ProviderScope`** is set up in `main.dart` — never duplicate it
7. **Use `ref.invalidate()`** to force-refresh data (e.g., on app resume)

## Provider patterns

### FutureProvider (data loading)
```dart
final feedProvider = FutureProvider<List<CurrentAffair>>((ref) async {
  final repo = ref.watch(contentRepositoryProvider);
  final result = await repo.loadEntries();
  return result.fold(
    onOk: (entries) => entries,
    onErr: (error, _) => throw error,
  );
});
```

### FutureProvider.family (parameterized)
```dart
final detailProvider = FutureProvider.family<CurrentAffair?, String>((
  ref,
  entryId,
) async {
  final repo = ref.watch(contentRepositoryProvider);
  final result = await repo.loadEntry(entryId);
  return result.fold(onOk: (e) => e, onErr: (error, _) => throw error);
});
```

### StateNotifierProvider (complex state)
```dart
final bookmarksProvider = StateNotifierProvider<BookmarksNotifier, Set<String>>((
  ref,
) {
  return BookmarksNotifier();
});

class BookmarksNotifier extends StateNotifier<Set<String>> {
  BookmarksNotifier() : super({}) { _load(); }
  // ... load, toggle, remove, persist methods
}
```

### Derived Provider (combining state)
```dart
final bookmarkedEntriesProvider = Provider<AsyncValue<List<CurrentAffair>>>((
  ref,
) {
  final ids = ref.watch(bookmarksProvider);
  final feed = ref.watch(feedProvider);
  return feed.whenData(
    (entries) => entries.where((e) => ids.contains(e.id)).toList(),
  );
});
```

## UI integration
```dart
class FeedScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(feedProvider);

    return feedAsync.when(
      data: (entries) => ListView.builder(/* ... */),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => ErrorWidget(/* ... */),
    );
  }
}
```

## Dependency injection
- Repositories are injected via `Provider<Repository>`
- Never instantiate dependencies directly in widgets
- Use `ProviderScope.overrides` in tests to inject mocks
