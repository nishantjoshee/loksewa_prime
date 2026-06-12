import 'package:json_annotation/json_annotation.dart';

part 'current_affair.g.dart';

/// Single current affairs entry for Loksewa exam preparation.
/// Bilingual: Nepali (required) and English (optional).
///
/// JSON uses snake_case keys; Dart fields use camelCase.
@JsonSerializable()
class CurrentAffair {
  final String id;

  @JsonKey(name: 'title_np')
  final String titleNp;

  @JsonKey(name: 'title_en')
  final String titleEn;

  @JsonKey(name: 'summary_np')
  final String summaryNp;

  @JsonKey(name: 'summary_en')
  final String summaryEn;

  final String category;

  @JsonKey(name: 'category_en')
  final String categoryEn;

  final String date;
  final String source;
  final List<String> tags;

  const CurrentAffair({
    required this.id,
    required this.titleNp,
    required this.titleEn,
    required this.summaryNp,
    required this.summaryEn,
    required this.category,
    required this.categoryEn,
    required this.date,
    required this.source,
    required this.tags,
  });

  factory CurrentAffair.fromJson(Map<String, dynamic> json) =>
      _$CurrentAffairFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentAffairToJson(this);
}
