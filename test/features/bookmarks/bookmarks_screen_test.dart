import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loksewa_prime/core/result.dart';
import 'package:loksewa_prime/data/models/current_affair.dart';
import 'package:loksewa_prime/data/repository/content_repo.dart';
import 'package:loksewa_prime/features/bookmarks/bookmarks_providers.dart';
import 'package:loksewa_prime/features/bookmarks/bookmarks_screen.dart';
import 'package:loksewa_prime/core/theme.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockContentRepository extends Mock implements ContentRepository {}

const testEntry = CurrentAffair(
  id: '1',
  titleNp: 'परीक्षण शीर्षक',
  titleEn: 'Test Title',
  summaryNp: 'यो परीक्षण समाचार हो।',
  summaryEn: 'This is a test entry.',
  category: 'राजनीति',
  categoryEn: 'Politics',
  date: '2026-06-10',
  source: 'Test Source',
  tags: ['test'],
);

void main() {
  late MockContentRepository mockRepo;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockRepo = MockContentRepository();
  });

  Widget buildTestApp({Set<String> bookmarkIds = const {}}) {
    return ProviderScope(
      overrides: [
        contentRepositoryProvider.overrideWithValue(mockRepo),
        bookmarksProvider.overrideWith((ref) {
          final notifier = BookmarksNotifier();
          for (final id in bookmarkIds) {
            notifier.toggle(id);
          }
          return notifier;
        }),
      ],
      child: MaterialApp(theme: AppTheme.light, home: const BookmarksScreen()),
    );
  }

  group('BookmarksScreen', () {
    testWidgets('shows empty state when no bookmarks', (tester) async {
      when(
        () => mockRepo.loadEntries(),
      ).thenAnswer((_) async => const Ok([testEntry]));

      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.text('कुनै बुकमार्क छैन'), findsOneWidget);
    });

    testWidgets('renders bookmarked entries', (tester) async {
      when(
        () => mockRepo.loadEntries(),
      ).thenAnswer((_) async => const Ok([testEntry]));

      await tester.pumpWidget(buildTestApp(bookmarkIds: {'1'}));
      await tester.pumpAndSettle();

      expect(find.text('परीक्षण शीर्षक'), findsOneWidget);
      expect(find.byIcon(Icons.bookmark), findsOneWidget);
    });

    testWidgets('shows error state when feed fails', (tester) async {
      when(
        () => mockRepo.loadEntries(),
      ).thenAnswer((_) async => const Err('Failed'));

      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('सामग्री लोड गर्न सकिएन'), findsOneWidget);
    });

    testWidgets('renders AppBar with bookmarks title', (tester) async {
      when(
        () => mockRepo.loadEntries(),
      ).thenAnswer((_) async => const Ok(<CurrentAffair>[]));

      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.text('बुकमार्क'), findsOneWidget);
    });
  });
}
