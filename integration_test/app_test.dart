import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:loksewa_prime/app.dart';
import 'package:loksewa_prime/core/ui_strings.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end', () {
    testWidgets('launch → view feed → tap search → view bookmarks', (
      tester,
    ) async {
      await tester.pumpWidget(const ProviderScope(child: App()));
      await tester.pumpAndSettle();

      // App starts on feed screen
      expect(find.text(UiStrings.appTitleNp), findsOneWidget);

      // Feed screen has search and bookmark action buttons
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.bookmark_border), findsOneWidget);

      // Tap search icon navigates to search screen
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();
      expect(find.text(UiStrings.searchNp), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);

      // Navigate to bookmarks
      await tester.pageBack();
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.bookmark_border));
      await tester.pumpAndSettle();
      expect(find.text(UiStrings.bookmarksNp), findsOneWidget);
    });
  });
}
