---
paths:
  - "test/**/*.dart"
  - "lib/**/*.dart"
---

# Testing Conventions

## Test file structure
- `test/features/<name>/` mirrors `lib/features/<name>/`
- `test/data/models/` for JSON serialization tests
- `test/data/repository/` for repository logic tests

## Test types

### Unit tests
- Test provider logic in isolation
- Test model `fromJson`/`toJson` with real JSON fixtures
- Use `mocktail` for dependencies

### Widget tests
- `pumpWidget` with `ProviderScope` wrapping tested widgets
- Override providers with `ProviderScope.overrides` for controlled state
- Use `tester.pumpAndSettle()` for async widgets

### Repository tests
- Test against real JSON in `assets/content/`
- Test search, filter, date-filtering logic
- Test caching behavior

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
    registerFallbackValue(const CurrentAffair(/*...*/));
  });
}
```
