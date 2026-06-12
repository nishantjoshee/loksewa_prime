---
paths:
  - "lib/**/*.dart"
---

# Riverpod State Management Patterns

## Provider types we use
- `FutureProvider` — for async data loading (feed, search results)
- `StateProvider` — for simple mutable state (selected category, language toggle)
- `Notifier`/`AsyncNotifier` — for complex state with actions
- `Provider` — for repository/service injection

## Rules
1. **Always prefer `ConsumerWidget` over `Consumer` widget** — cleaner syntax
2. **Use `ref.watch()` in build methods** for reactive updates
3. **Use `ref.read()` in callbacks** (onTap, onPressed) to avoid unnecessary rebuilds
4. **Keep providers in a separate file**: `<feature>_providers.dart`
5. **Use code generation** (`@riverpod`) for new providers — annotate and run build_runner
6. **`ProviderScope`** is set up in `main.dart` — never duplicate it

## Example: Feature provider file

```dart
// lib/features/feed/feed_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_providers.g.dart';

@riverpod
Future<List<CurrentAffair>> feed(FeedRef ref) async {
  final repo = ref.watch(contentRepositoryProvider);
  return repo.loadEntries();
}
```

## Dependency injection
- Repositories are injected via `Provider<Repository>`
- Services (future: API client, cache) are injected the same way
- Never instantiate dependencies directly in widgets
