import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loksewa_prime/features/settings/settings_screen.dart';
import 'package:loksewa_prime/core/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget buildTestApp() {
    return ProviderScope(
      child: MaterialApp(theme: AppTheme.light, home: const SettingsScreen()),
    );
  }

  group('SettingsScreen', () {
    testWidgets('renders all setting sections', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.text('भाषा'), findsOneWidget);
      expect(find.text('अक्षरको आकार'), findsOneWidget);
      expect(find.text('थिम'), findsOneWidget);
      expect(find.text('बारेमा'), findsOneWidget);
    });

    testWidgets('shows language toggle with Nepali selected by default', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      expect(find.text('नेपाली'), findsWidgets);
      expect(find.text('EN'), findsOneWidget);
    });

    testWidgets('has font size slider', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('has theme toggle buttons', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.byType(SegmentedButton<ThemeMode>), findsOneWidget);
    });

    testWidgets('shows about section with version', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.text('Loksewa Prime v1.0.0'), findsOneWidget);
    });
  });
}
