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
- **Core layer**: `lib/core/` for app-wide config (theme, router, constants)
- **State management**: Riverpod with code generation (`@riverpod` annotations)
- **Navigation**: GoRouter, centralized in `lib/core/router.dart`
- **Tests mirror source**: `test/features/<name>/` mirrors `lib/features/<name>/`

## Riverpod Conventions

- Use `@riverpod` annotation + code generation for new providers
- Provider names are descriptive: `feedProvider`, `bookmarksProvider`, `searchProvider`
- `FutureProvider` for async data loading
- `NotifierProvider` for mutable state
- Widgets extend `ConsumerWidget` or `ConsumerStatefulWidget`
- Always `ref.watch()` for reactive reads, `ref.read()` for callbacks

## Data Model

- All content models use `@JsonSerializable()` with `fromJson`/`toJson`
- Run `dart run build_runner build` after editing models
- Bilingual fields: `fieldNp` (Nepali, required) and `fieldEn` (English, required)
- Content bundled in `assets/content/current_affairs.json`

## Testing Conventions

- Every feature gets unit tests in `test/features/<name>/`
- Widget tests with `pumpWidget` for screen-level tests
- Repository tests use real JSON parsing (integration-light)
- Mock dependencies with `mocktail` — no real network calls in tests
- Test file naming: `<name>_test.dart`
- Aim for >80% coverage on repository and provider logic

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
