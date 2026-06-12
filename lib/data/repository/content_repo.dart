import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/current_affair.dart';
import '../../core/constants.dart';

final contentRepositoryProvider = Provider<ContentRepository>((ref) {
  return ContentRepository();
});

class ContentRepository {
  List<CurrentAffair>? _cached;

  Future<List<CurrentAffair>> loadEntries() async {
    if (_cached != null) return _cached!;

    final jsonStr = await rootBundle.loadString(AppConstants.contentAssetPath);
    final Map<String, dynamic> data =
        json.decode(jsonStr) as Map<String, dynamic>;
    final List<dynamic> entriesJson = data['entries'] as List<dynamic>;

    _cached = entriesJson
        .map((e) => CurrentAffair.fromJson(e as Map<String, dynamic>))
        .toList();
    return _cached!;
  }

  Future<CurrentAffair?> loadEntry(String id) async {
    final entries = await loadEntries();
    try {
      return entries.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<CurrentAffair>> loadByDate(String dateStr) async {
    final entries = await loadEntries();
    return entries.where((e) => e.date == dateStr).toList();
  }

  Future<List<CurrentAffair>> loadByCategory(String categoryNp) async {
    final entries = await loadEntries();
    return entries.where((e) => e.category == categoryNp).toList();
  }

  Future<List<CurrentAffair>> search(String query) async {
    final entries = await loadEntries();
    final lowerQuery = query.toLowerCase();
    return entries.where((e) {
      return e.titleNp.toLowerCase().contains(lowerQuery) ||
          e.titleEn.toLowerCase().contains(lowerQuery) ||
          e.summaryNp.toLowerCase().contains(lowerQuery) ||
          e.summaryEn.toLowerCase().contains(lowerQuery) ||
          e.tags.any((t) => t.toLowerCase().contains(lowerQuery));
    }).toList();
  }
}
