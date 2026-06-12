import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loksewa_prime/core/result.dart';
import 'package:loksewa_prime/data/models/current_affair.dart';
import 'package:loksewa_prime/data/repository/content_repo.dart';
import 'package:loksewa_prime/features/search/search_screen.dart';
import 'package:loksewa_prime/core/theme.dart';
import 'package:mocktail/mocktail.dart';

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
    mockRepo = MockContentRepository();
  });

  Widget buildTestApp() {
    return ProviderScope(
      overrides: [contentRepositoryProvider.overrideWithValue(mockRepo)],
      child: MaterialApp(theme: AppTheme.light, home: const SearchScreen()),
    );
  }

  group('SearchScreen', () {
    testWidgets('shows start-searching state by default', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.text('खोजी सुरु गर्नुहोस्'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('shows no-results when query has no matches', (tester) async {
      when(
        () => mockRepo.search(any()),
      ).thenAnswer((_) async => const Ok(<CurrentAffair>[]));

      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'nonexistent');
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      expect(find.text('कुनै परिणाम भेटिएन'), findsOneWidget);
    });

    testWidgets('shows search results when query matches', (tester) async {
      when(
        () => mockRepo.search('test'),
      ).thenAnswer((_) async => const Ok([testEntry]));

      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      expect(find.text('परीक्षण शीर्षक'), findsOneWidget);
      expect(find.text('Test Title'), findsOneWidget);
    });

    testWidgets('clear button resets search', (tester) async {
      when(
        () => mockRepo.search(any()),
      ).thenAnswer((_) async => const Ok(<CurrentAffair>[]));

      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'test');
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      expect(find.text('खोजी सुरु गर्नुहोस्'), findsOneWidget);
    });

    testWidgets('renders AppBar with search title', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.text('खोजी'), findsOneWidget);
    });
  });
}
