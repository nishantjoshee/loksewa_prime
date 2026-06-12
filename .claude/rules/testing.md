---
paths:
  - "test/**/*.dart"
---

# Testing Conventions

## Test file structure
- `test/features/<name>/` mirrors `lib/features/<name>/`
- `test/data/models/` for JSON serialization tests
- `test/data/repository/` for repository logic tests
- `test/core/` for core utility tests (Result type, etc.)

## Test types

### Unit tests
- Test model `fromJson`/`toJson` with real JSON fixtures
- Test Result type with Ok/Err variants
- Use `mocktail` for external dependencies

### Repository tests
- Test against real JSON in `assets/content/current_affairs.json`
- Test loadEntries, loadEntry, loadByDate, loadByCategory, search
- Test caching behavior (second call returns same instance)
- Test error handling (missing asset)

### Provider tests
- Test `FutureProvider` with mocked repository returning `Ok()` / `Err()`
- Test `StateNotifier` state transitions and persistence
- Use `ProviderScope.overrides` for controlled dependencies

### Widget tests
- `pumpWidget` with `ProviderScope` wrapping tested widgets
- Override providers with `ProviderScope.overrides` for controlled state
- Use `tester.pumpAndSettle()` for async widgets
- Test loading, data, error, and empty states for every screen

### Golden tests
- FeedScreen with test data
- DetailScreen with single entry
- Empty states (bookmarks, search)

## Running tests
```bash
flutter test                    # all tests
flutter test --coverage         # with coverage
flutter test test/features/feed/ # specific directory
```

## Mock patterns (mocktail)

```dart
import 'package:mocktail/mocktail.dart';

class MockRepo extends Mock implements ContentRepository {}

void main() {
  late MockRepo mockRepo;

  setUp(() {
    mockRepo = MockRepo();
  });

  testWidgets('shows data', (tester) async {
    when(() => mockRepo.loadEntries())
        .thenAnswer((_) async => Ok(testEntries));

    await tester.pumpWidget(ProviderScope(
      overrides: [contentRepositoryProvider.overrideWithValue(mockRepo)],
      child: MaterialApp(home: FeedScreen()),
    ));
    await tester.pumpAndSettle();
  });
}
```

## Coverage
- CI enforces >80% coverage
- Repository and provider logic target >90%
- Focus coverage on data layer and business logic
