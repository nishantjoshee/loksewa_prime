---
description: Run Flutter tests for Loksewa Prime with coverage. Use when asked to run tests, check tests, or verify test coverage.
argument-hint: "[path]"
---

## Run Tests

### Run all tests
```
cd ${CLAUDE_PROJECT_DIR} && flutter test
```

### Run tests with coverage
```
cd ${CLAUDE_PROJECT_DIR} && flutter test --coverage
```

### Run tests in a specific path
```
cd ${CLAUDE_PROJECT_DIR} && flutter test <path>
```

### Run a single test file
```
cd ${CLAUDE_PROJECT_DIR} && flutter test test/features/feed/feed_screen_test.dart
```

## After running tests

1. Report the number of tests passed, failed, and skipped.
2. If any tests failed, show the failure messages clearly.
3. If coverage is low in a specific area, suggest where to add tests.

## Project test structure

- `test/features/<feature>/` — unit + widget tests per feature
- `test/data/models/` — model serialization tests
- `test/data/repository/` — repository logic tests
