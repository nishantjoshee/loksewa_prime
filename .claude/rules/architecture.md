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

## Comments
- **No "what" comments** — the code should be self-documenting. Delete comments that narrate what the code does (e.g. `// Navigate to detail`, `// Title in Nepali`, `// Verify both entries appear`).
- **No class-level doc comments** that just restate the widget/class name (e.g. `/// Feed screen — shows the feed.`).
- **No section-marker comments** in constants, theme, or layout files — group with spacing instead.
- **Keep only business-logic "why" comments**: design rationale (e.g. `// Optimized for Nepali Devanagari + English mixed text`), non-obvious constraints, JSON mapping conventions.
- Exception: auto-generated files (`.g.dart`) and analyzer pragmas (`// ignore:`) are never cleaned up.
