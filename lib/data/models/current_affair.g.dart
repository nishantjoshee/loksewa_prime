// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_affair.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentAffair _$CurrentAffairFromJson(Map<String, dynamic> json) =>
    CurrentAffair(
      id: json['id'] as String,
      titleNp: json['title_np'] as String,
      titleEn: json['title_en'] as String,
      summaryNp: json['summary_np'] as String,
      summaryEn: json['summary_en'] as String,
      category: json['category'] as String,
      categoryEn: json['category_en'] as String,
      date: json['date'] as String,
      source: json['source'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$CurrentAffairToJson(CurrentAffair instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title_np': instance.titleNp,
      'title_en': instance.titleEn,
      'summary_np': instance.summaryNp,
      'summary_en': instance.summaryEn,
      'category': instance.category,
      'category_en': instance.categoryEn,
      'date': instance.date,
      'source': instance.source,
      'tags': instance.tags,
    };
