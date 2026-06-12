---
paths:
  - "lib/**/*.dart"
  - ".claude/**"
---

# Loksewa Prime Architecture

## Layer dependency flow
```
UI (features/*) → Providers → Repository → Data source (JSON/API)
                      ↑              ↑
                  Riverpod       Model classes
```

## Rules
1. **Features never import from other features directly** — share via providers only
2. **Repository is the single source of truth** — all data flows through it
3. **Models are immutable** — all fields `final`, use `copyWith` if needed
4. **Core layer has no dependencies on features** — theme, router, constants are independent
5. **Assets are loaded via `rootBundle`** — always use the repository abstraction, never directly

## File naming
- Screens: `<feature>_screen.dart`
- Providers: `<feature>_providers.dart`
- Models: `snake_case.dart`
- Repositories: `<name>_repo.dart`
- Widgets: `snake_case.dart` in `widgets/` subdirectory

## When to create a new feature folder
- A distinct screen or user flow (search, bookmarks, detail, settings)
- Has its own providers and potentially its own widgets
- Starts small (screen + provider) and grows

## When NOT to create a new feature folder
- A single reusable widget → goes in `lib/core/widgets/` or feature's `widgets/`
- A data model → goes in `lib/data/models/`

## Result type
- All repository methods return `Result<T>` (`Ok(T value)` | `Err(Object error, StackTrace? stack)`)
- Providers unwrap with `result.fold(onOk: ..., onErr: (error, _) => throw error)` to trigger FutureProvider error states
- Never ignore the error case — every `Result` must be folded or pattern-matched

## Error handling
- Repository catches all exceptions, wraps in `Err`, reports via `ErrorReporter`
- Providers throw errors to trigger `AsyncValue.error` state
- Every screen shows loading, data, and error states via `.when()`
- `ErrorReporter.init()` is called in `main()` — catches `FlutterError` and `PlatformDispatcher` errors

## Accessibility
- Every interactive widget gets a `Semantics` wrapper with `label` and `button`/`hint` properties
- Info text (titles, summaries) gets `Semantics(label: ...)` for screen readers
- Labels are in Nepali by default; English variants available via `UiStrings`
- Icons have `semanticLabel` set

## Localization
- UI strings are centralized in `lib/core/ui_strings.dart` as bilingual constants (`fieldNp` + `fieldEn`)
- Settings screen controls language preference (`np`/`en`), persisted via SharedPreferences
- Content model already bilingual — UI must match content language

## Performance
- `RepaintBoundary` around card widgets in scrollable lists
- `const` constructors everywhere possible
- Shared `TextTheme`/`AppBarTheme`/`InputDecorationTheme` extracted as constants in `AppTheme`
- `ListView.builder` for all lists (never `ListView(children: [...])` for dynamic data)

## Comments
- **No "what" comments** — the code should be self-documenting. Delete comments that narrate what the code does
- **No class-level doc comments** that just restate the widget/class name
- **No section-marker comments** in constants, theme, or layout files — group with spacing instead
- **Keep only business-logic "why" comments**: design rationale, non-obvious constraints, JSON mapping conventions
- Exception: auto-generated files (`.g.dart`) and analyzer pragmas (`// ignore:`) are never cleaned up
