import 'package:flutter_test/flutter_test.dart';
import 'package:loksewa_prime/data/repository/content_repo.dart';

void main() {
  late ContentRepository repo;

  setUp(() {
    repo = ContentRepository();
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('loadEntries', () {
    test('returns all entries from bundled JSON', () async {
      final result = await repo.loadEntries();

      expect(result.isOk, isTrue);
      final entries = result.okOrNull!;
      expect(entries.length, greaterThanOrEqualTo(3));
    });

    test('caches results on second call', () async {
      final result1 = await repo.loadEntries();
      final result2 = await repo.loadEntries();

      expect(result1.okOrNull, same(result2.okOrNull));
    });
  });

  group('loadEntry', () {
    test('finds entry by ID', () async {
      final result = await repo.loadEntry('1');
      expect(result.isOk, isTrue);
      expect(result.okOrNull!.id, '1');
    });

    test('returns null for invalid ID', () async {
      final result = await repo.loadEntry('nonexistent');
      expect(result.isOk, isTrue);
      expect(result.okOrNull, isNull);
    });
  });

  group('loadByDate', () {
    test('filters entries by date correctly', () async {
      final result = await repo.loadByDate('2026-06-10');
      expect(result.isOk, isTrue);

      final entries = result.okOrNull!;
      for (final entry in entries) {
        expect(entry.date, '2026-06-10');
      }
    });

    test('returns empty list for date with no entries', () async {
      final result = await repo.loadByDate('1999-01-01');
      expect(result.isOk, isTrue);
      expect(result.okOrNull, isEmpty);
    });
  });

  group('loadByCategory', () {
    test('filters by Nepali category', () async {
      final result = await repo.loadByCategory('खेलकुद');
      expect(result.isOk, isTrue);

      final entries = result.okOrNull!;
      for (final entry in entries) {
        expect(entry.category, 'खेलकुद');
      }
    });
  });

  group('search', () {
    test('matches Nepali title', () async {
      final result = await repo.search('विद्युत्');
      expect(result.isOk, isTrue);
      expect(result.okOrNull!.any((e) => e.id == '1'), isTrue);
    });

    test('matches English title', () async {
      final result = await repo.search('electricity');
      expect(result.isOk, isTrue);
      expect(result.okOrNull!.any((e) => e.id == '1'), isTrue);
    });

    test('matches tags', () async {
      final result = await repo.search('cricket');
      expect(result.isOk, isTrue);
      expect(result.okOrNull!.any((e) => e.id == '5'), isTrue);
    });

    test('is case-insensitive', () async {
      final result1 = await repo.search('NEPAL');
      final result2 = await repo.search('nepal');

      expect(result1.isOk, isTrue);
      expect(result2.isOk, isTrue);
      expect(result1.okOrNull!.length, result2.okOrNull!.length);
    });

    test('returns empty for non-matching query', () async {
      final result = await repo.search('xyznonexistent123');
      expect(result.isOk, isTrue);
      expect(result.okOrNull, isEmpty);
    });
  });
}
