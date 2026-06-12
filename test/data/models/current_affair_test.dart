import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:loksewa_prime/data/models/current_affair.dart';

void main() {
  group('CurrentAffair', () {
    const testJson = '''
    {
      "id": "1",
      "title_np": "नेपालले बंगलादेशलाई विद्युत् निर्यात",
      "title_en": "Nepal exports electricity to Bangladesh",
      "summary_np": "नेपाल विद्युत् प्राधिकरणले विद्युत् निर्यात सुरु गरेको छ।",
      "summary_en": "Nepal Electricity Authority has started exporting electricity.",
      "category": "अर्थतन्त्र",
      "category_en": "Economy",
      "date": "2026-06-10",
      "source": "Gorkhapatra",
      "tags": ["energy", "export"]
    }
    ''';

    test('fromJson parses all fields correctly', () {
      final Map<String, dynamic> jsonMap =
          json.decode(testJson) as Map<String, dynamic>;
      final entry = CurrentAffair.fromJson(jsonMap);

      expect(entry.id, '1');
      expect(entry.titleNp, 'नेपालले बंगलादेशलाई विद्युत् निर्यात');
      expect(entry.titleEn, 'Nepal exports electricity to Bangladesh');
      expect(entry.category, 'अर्थतन्त्र');
      expect(entry.categoryEn, 'Economy');
      expect(entry.date, '2026-06-10');
      expect(entry.source, 'Gorkhapatra');
      expect(entry.tags, ['energy', 'export']);
    });

    test('toJson produces valid JSON for all fields', () {
      const entry = CurrentAffair(
        id: '1',
        titleNp: 'नेपालले बंगलादेशलाई विद्युत् निर्यात',
        titleEn: 'Nepal exports electricity to Bangladesh',
        summaryNp: 'नेपाल विद्युत् प्राधिकरणले विद्युत् निर्यात सुरु गरेको छ।',
        summaryEn:
            'Nepal Electricity Authority has started exporting electricity.',
        category: 'अर्थतन्त्र',
        categoryEn: 'Economy',
        date: '2026-06-10',
        source: 'Gorkhapatra',
        tags: ['energy', 'export'],
      );

      final json = entry.toJson();

      expect(json['id'], '1');
      expect(json['title_np'], 'नेपालले बंगलादेशलाई विद्युत् निर्यात');
      expect(json['title_en'], 'Nepal exports electricity to Bangladesh');
      expect(json['tags'], ['energy', 'export']);
    });

    test('round-trip: fromJson → toJson preserves data', () {
      final Map<String, dynamic> original =
          json.decode(testJson) as Map<String, dynamic>;
      final entry = CurrentAffair.fromJson(original);
      final result = entry.toJson();

      expect(result['id'], original['id']);
      expect(result['title_np'], original['title_np']);
      expect(result['title_en'], original['title_en']);
      expect(result['category'], original['category']);
      expect(result['tags'], original['tags']);
    });
  });
}
