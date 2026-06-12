import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loksewa_prime/core/result.dart';
import 'package:loksewa_prime/data/models/current_affair.dart';
import 'package:loksewa_prime/data/repository/content_repo.dart';
import 'package:loksewa_prime/features/detail/detail_screen.dart';
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
  tags: ['test', 'pilot'],
);

void main() {
  late MockContentRepository mockRepo;

  setUp(() {
    mockRepo = MockContentRepository();
  });

  Widget buildTestApp(String entryId) {
    return ProviderScope(
      overrides: [contentRepositoryProvider.overrideWithValue(mockRepo)],
      child: MaterialApp(
        theme: AppTheme.light,
        home: DetailScreen(entryId: entryId),
      ),
    );
  }

  group('DetailScreen', () {
    testWidgets('shows loading indicator initially', (tester) async {
      when(
        () => mockRepo.loadEntry(any()),
      ).thenAnswer((_) => Completer<Result<CurrentAffair?>>().future);

      await tester.pumpWidget(buildTestApp('1'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders entry details when loaded', (tester) async {
      when(
        () => mockRepo.loadEntry('1'),
      ).thenAnswer((_) async => const Ok(testEntry));

      await tester.pumpWidget(buildTestApp('1'));
      await tester.pumpAndSettle();

      expect(find.text('परीक्षण शीर्षक'), findsOneWidget);
      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('राजनीति'), findsOneWidget);
      expect(find.text('यो परीक्षण समाचार हो।'), findsOneWidget);
      expect(find.text('test'), findsOneWidget);
      expect(find.text('pilot'), findsOneWidget);
    });

    testWidgets('shows not-found message for missing entry', (tester) async {
      when(
        () => mockRepo.loadEntry('nonexistent'),
      ).thenAnswer((_) async => const Ok(null));

      await tester.pumpWidget(buildTestApp('nonexistent'));
      await tester.pumpAndSettle();

      expect(find.text('कुनै परिणाम भेटिएन'), findsOneWidget);
    });

    testWidgets('has bookmark and share buttons', (tester) async {
      when(
        () => mockRepo.loadEntry('1'),
      ).thenAnswer((_) async => const Ok(testEntry));

      await tester.pumpWidget(buildTestApp('1'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
      expect(find.byIcon(Icons.share), findsOneWidget);
    });

    testWidgets('renders metadata row with date and source', (tester) async {
      when(
        () => mockRepo.loadEntry('1'),
      ).thenAnswer((_) async => const Ok(testEntry));

      await tester.pumpWidget(buildTestApp('1'));
      await tester.pumpAndSettle();

      expect(find.textContaining('2026-06-10'), findsOneWidget);
      expect(find.textContaining('Test Source'), findsOneWidget);
    });
  });
}
