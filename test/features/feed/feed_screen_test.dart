import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loksewa_prime/data/models/current_affair.dart';
import 'package:loksewa_prime/data/repository/content_repo.dart';
import 'package:loksewa_prime/features/feed/feed_screen.dart';
import 'package:loksewa_prime/core/theme.dart';
import 'package:mocktail/mocktail.dart';

class MockContentRepository extends Mock implements ContentRepository {}

void main() {
  late MockContentRepository mockRepo;

  final testEntries = [
    const CurrentAffair(
      id: '1',
      titleNp: 'नेपालले बंगलादेशलाई ४० मेगावाट विद्युत् निर्यात सुरु',
      titleEn: 'Nepal begins exporting 40MW electricity to Bangladesh',
      summaryNp:
          'नेपाल विद्युत् प्राधिकरणले भारतीय प्रसारण लाइन हुँदै बंगलादेशलाई ४० मेगावाट विद्युत् निर्यात सुरु गरेको छ।',
      summaryEn:
          'Nepal Electricity Authority has started exporting 40MW of electricity to Bangladesh via Indian transmission lines.',
      category: 'अर्थतन्त्र',
      categoryEn: 'Economy',
      date: '2026-06-10',
      source: 'Gorkhapatra',
      tags: ['energy', 'export'],
    ),
    const CurrentAffair(
      id: '2',
      titleNp: 'सरकारले नयाँ शिक्षा नीति सार्वजनिक गर्याे',
      titleEn: 'Government unveils new education policy',
      summaryNp:
          'शिक्षा मन्त्रालयले २०८३ सालदेखि लागु हुने नयाँ राष्ट्रिय शिक्षा नीति सार्वजनिक गरेको छ।',
      summaryEn:
          'The Ministry of Education has unveiled the new National Education Policy effective from 2083 BS.',
      category: 'राजनीति',
      categoryEn: 'Politics',
      date: '2026-06-09',
      source: 'Kantipur',
      tags: ['education', 'policy'],
    ),
  ];

  setUp(() {
    mockRepo = MockContentRepository();
  });

  Widget buildTestApp() {
    return ProviderScope(
      overrides: [contentRepositoryProvider.overrideWithValue(mockRepo)],
      child: MaterialApp(theme: AppTheme.light, home: FeedScreen()),
    );
  }

  group('FeedScreen UI', () {
    testWidgets('shows loading indicator while fetching data', (tester) async {
      // ignore: discarded_futures
      when(
        () => mockRepo.loadEntries(),
      ).thenAnswer((_) => Completer<List<CurrentAffair>>().future);

      await tester.pumpWidget(buildTestApp());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders Nepali title in AppBar', (tester) async {
      when(() => mockRepo.loadEntries()).thenAnswer((_) async => testEntries);

      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.text('लोकसेवा प्राइम'), findsOneWidget);
    });

    testWidgets('renders all entry cards with Nepali text', (tester) async {
      when(() => mockRepo.loadEntries()).thenAnswer((_) async => testEntries);

      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(
        find.text('नेपालले बंगलादेशलाई ४० मेगावाट विद्युत् निर्यात सुरु'),
        findsOneWidget,
      );
      expect(
        find.text('सरकारले नयाँ शिक्षा नीति सार्वजनिक गर्याे'),
        findsOneWidget,
      );

      expect(
        find.text('Nepal begins exporting 40MW electricity to Bangladesh'),
        findsOneWidget,
      );
      expect(
        find.text('Government unveils new education policy'),
        findsOneWidget,
      );
    });

    testWidgets('renders category chips for each entry', (tester) async {
      when(() => mockRepo.loadEntries()).thenAnswer((_) async => testEntries);

      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.text('अर्थतन्त्र'), findsOneWidget);
      expect(find.text('राजनीति'), findsOneWidget);
    });

    testWidgets('renders metadata (date + source) for each entry', (
      tester,
    ) async {
      when(() => mockRepo.loadEntries()).thenAnswer((_) async => testEntries);

      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.text('2026-06-10'), findsOneWidget);
      expect(find.text('Gorkhapatra'), findsOneWidget);
      expect(find.text('2026-06-09'), findsOneWidget);
      expect(find.text('Kantipur'), findsOneWidget);
    });

    testWidgets('renders Nepali summary with text overflow handling', (
      tester,
    ) async {
      when(() => mockRepo.loadEntries()).thenAnswer((_) async => testEntries);

      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(
        find.text(
          'नेपाल विद्युत् प्राधिकरणले भारतीय प्रसारण लाइन हुँदै बंगलादेशलाई ४० मेगावाट विद्युत् निर्यात सुरु गरेको छ।',
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders AppBar action buttons', (tester) async {
      when(() => mockRepo.loadEntries()).thenAnswer((_) async => testEntries);

      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
    });

    testWidgets('renders Card widgets with InkWell for tap interaction', (
      tester,
    ) async {
      when(() => mockRepo.loadEntries()).thenAnswer((_) async => testEntries);

      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.byType(Card), findsWidgets);
      expect(find.byType(InkWell), findsWidgets);
    });

    testWidgets('shows error state when repository fails', (tester) async {
      when(
        () => mockRepo.loadEntries(),
      ).thenThrow(Exception('Failed to load content'));

      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('सामग्री लोड गर्न सकिएन'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });
  });
}
