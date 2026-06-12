---
description: Generate Flutter code following Loksewa Prime conventions. Use when asked to create a new feature, screen, widget, provider, or model.
---

## Code Generation Rules

When generating new code for Loksewa Prime, follow these patterns.

## New Feature Checklist

A complete feature needs:
- [ ] Screen file: `lib/features/<name>/<name>_screen.dart`
- [ ] Providers file: `lib/features/<name>/<name>_providers.dart`
- [ ] Widgets directory: `lib/features/<name>/widgets/` (if complex)
- [ ] Route entry in `lib/core/router.dart`
- [ ] Test file: `test/features/<name>/<name>_screen_test.dart`

## Screen Template

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyFeatureScreen extends ConsumerWidget {
  const MyFeatureScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen Title'),
      ),
      body: const Center(
        child: Text('Content'),
      ),
    );
  }
}
```

## Provider Template

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Async data loading
final myDataProvider = FutureProvider<List<MyData>>((ref) async {
  final repo = ref.watch(myRepositoryProvider);
  return repo.loadData();
});

// Mutable state
final myStateProvider = StateProvider<int>((ref) => 0);
```

## Model Template

```dart
import 'package:json_annotation/json_annotation.dart';
part 'my_model.g.dart';

@JsonSerializable()
class MyModel {
  final String id;
  final String labelNp;
  final String labelEn;

  const MyModel({
    required this.id,
    required this.labelNp,
    required this.labelEn,
  });

  factory MyModel.fromJson(Map<String, dynamic> json) =>
      _$MyModelFromJson(json);
  Map<String, dynamic> toJson() => _$MyModelToJson(this);
}
```

**After creating/modifying models:** run `dart run build_runner build --delete-conflicting-outputs`

## Router Entry Template

```dart
GoRoute(
  path: '/my-feature',
  pageBuilder: (context, state) => const NoTransitionPage(
    child: MyFeatureScreen(),
  ),
),
```

## Test Template

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('MyFeatureScreen', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MyApp()),
      );
      expect(find.text('Screen Title'), findsOneWidget);
    });
  });
}
```
