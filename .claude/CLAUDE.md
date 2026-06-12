# Loksewa Prime — Project Conventions

## Commands

| Task | Command |
|---|---|
| Run on iOS simulator | `open -a Simulator && flutter run -d <device-id>` |
| Run on connected device | `flutter run` |
| Run tests | `flutter test` |
| Run tests with coverage | `flutter test --coverage` |
| Static analysis | `flutter analyze` |
| Format code | `dart format lib/ test/` |
| Build iOS (debug) | `flutter build ios --debug --no-codesign` |
| Build iOS (release) | `flutter build ios --release --no-codesign` |
| Code generation | `dart run build_runner build --delete-conflicting-outputs` |
| Open DevTools | `flutter pub global run devtools` or `dart devtools` |
| List iOS simulators | `xcrun simctl list devices available` |
| Boot specific simulator | `xcrun simctl boot <device-id>` |

## Architecture

- **Feature-first**: `lib/features/<name>/` contains screen, providers, and widgets for each feature
- **Data layer**: `lib/data/models/` for data classes, `lib/data/repository/` for data access
- **Core layer**: `lib/core/` for app-wide config (theme, router, constants, Result type, ErrorReporter, UiStrings)
- **State management**: Riverpod (`FutureProvider`, `StateNotifierProvider`, `Provider`)
- **Navigation**: GoRouter, centralized in `lib/core/router.dart`
- **Tests mirror source**: `test/features/<name>/` mirrors `lib/features/<name>/`

## Result Type

- All repository methods return `Result<T>` — see `lib/core/result.dart`
- `Ok(T value)` for success, `Err(Object error, StackTrace? stack)` for failure
- Providers unwrap with `result.fold(onOk: ..., onErr: (error, _) => throw error)`
- Every screen handles loading, data, and error states via `AsyncValue.when()`

## Error Handling

- `ErrorReporter.init()` in `main()` catches FlutterError and PlatformDispatcher errors
- Repository catches all JSON/IO errors, wraps in `Err`, reports via ErrorReporter
- No bare `try/catch` outside repository — use Result propagation

## Accessibility

- Every interactive widget gets a `Semantics` wrapper with `label` and `button`/`hint`
- Icons have `semanticLabel` set
- Labels in Nepali by default; `UiStrings` class has bilingual variants

## Localization

- UI strings centralized in `lib/core/ui_strings.dart` as bilingual constants
- Settings screen persists language preference via SharedPreferences

## Riverpod Conventions

- Provider names are descriptive: `feedProvider`, `bookmarksProvider`, `searchProvider`
- `FutureProvider` for async data loading, `FutureProvider.family` for parameterized loading
- `StateNotifierProvider` for complex mutable state (bookmarks, settings)
- `StateProvider` for simple mutable state (selected category, search query)
- Widgets extend `ConsumerWidget` or `ConsumerStatefulWidget`
- `ref.watch()` for reactive reads, `ref.read()` in callbacks, `ref.invalidate()` for force-refresh
- See `.claude/rules/riverpod.md` for full patterns and examples

## Data Model

- All content models use `@JsonSerializable()` with `fromJson`/`toJson`
- Run `dart run build_runner build` after editing models
- Bilingual fields: `fieldNp` (Nepali, required) and `fieldEn` (English, required)
- Content bundled in `assets/content/current_affairs.json`

## Testing Conventions

- Every feature gets unit tests in `test/features/<name>/`
- Widget tests with `pumpWidget` for screen-level tests; test loading/data/error/empty states
- Repository tests use real JSON from `assets/content/` — no mocking for data layer
- Mock dependencies with `mocktail` — mock repo returns `Ok()`/`Err()` wrapped values
- Test file naming: `<name>_test.dart`
- CI enforces >80% coverage; repository and provider logic target >90%
- See `.claude/rules/testing.md` for full patterns and mock examples

## iOS-Specific Notes

- Minimum iOS version: check `ios/Podfile` — default is usually fine
- Simulator devices available: `xcrun simctl list devices available`
- Boot simulator before run: `open -a Simulator` or `xcrun simctl boot <UDID>`
- DevTools: `dart devtools` — opens in browser
- Hot reload: `r` in terminal, hot restart: `R`
- For TestFlight: needs Apple Developer account + certs + `flutter build ios --release`

## Nepali Text Handling

- Flutter's Material 3 text system handles Devanagari natively
- No special fonts needed — system fonts render Nepali correctly on iOS
- Use `height: 1.6` line height for Devanagari readability
- Right-align is NOT needed — Nepali reads LTR like English
- Date format in content: ISO 8601 (`YYYY-MM-DD`)

## Code Style

- **Minimal comments**: No "what" comments — code must be self-documenting. Keep only business-logic "why" comments (design rationale, constraints, conventions). See `.claude/rules/architecture.md` for the full policy.
- Run `dart format lib/ test/` before committing.

## Git Conventions

- Branch naming: `feature/short-desc`, `fix/short-desc`, `chore/short-desc`
- Commit messages: present tense, lowercase, descriptive
- No committing secrets or `.env` files
- `.claude/` is committed (team-shared config)
- `CLAUDE.local.md` is gitignored (personal overrides)
