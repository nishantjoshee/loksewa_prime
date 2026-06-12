import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/current_affair.dart';
import '../../core/constants.dart';
import '../../core/result.dart';
import '../../core/error_reporter.dart';

final contentRepositoryProvider = Provider<ContentRepository>((ref) {
  return ContentRepository();
});

class ContentRepository {
  List<CurrentAffair>? _cached;

  Future<Result<List<CurrentAffair>>> loadEntries() async {
    if (_cached != null) return Ok(_cached!);

    try {
      final jsonStr = await rootBundle.loadString(
        AppConstants.contentAssetPath,
      );
      final data = json.decode(jsonStr) as Map<String, dynamic>;
      final entriesJson = data['entries'] as List<dynamic>;

      _cached = entriesJson
          .map((e) => CurrentAffair.fromJson(e as Map<String, dynamic>))
          .toList();
      return Ok(_cached!);
    } catch (e, stack) {
      ErrorReporter.report(e, stack: stack);
      return Err(e, stack);
    }
  }

  Future<Result<CurrentAffair?>> loadEntry(String id) async {
    final result = await loadEntries();
    return result.fold(
      onOk: (entries) {
        try {
          return Ok(entries.firstWhere((e) => e.id == id));
        } catch (_) {
          return const Ok(null);
        }
      },
      onErr: (error, stack) => Err(error, stack),
    );
  }

  Future<Result<List<CurrentAffair>>> loadByDate(String dateStr) async {
    final result = await loadEntries();
    return result.fold(
      onOk: (entries) => Ok(entries.where((e) => e.date == dateStr).toList()),
      onErr: (error, stack) => Err(error, stack),
    );
  }

  Future<Result<List<CurrentAffair>>> loadByCategory(String categoryNp) async {
    final result = await loadEntries();
    return result.fold(
      onOk: (entries) =>
          Ok(entries.where((e) => e.category == categoryNp).toList()),
      onErr: (error, stack) => Err(error, stack),
    );
  }

  Future<Result<List<CurrentAffair>>> search(String query) async {
    final result = await loadEntries();
    return result.fold(
      onOk: (entries) {
        final lowerQuery = query.toLowerCase();
        final matches = entries.where((e) {
          return e.titleNp.toLowerCase().contains(lowerQuery) ||
              e.titleEn.toLowerCase().contains(lowerQuery) ||
              e.summaryNp.toLowerCase().contains(lowerQuery) ||
              e.summaryEn.toLowerCase().contains(lowerQuery) ||
              e.tags.any((t) => t.toLowerCase().contains(lowerQuery));
        }).toList();
        return Ok(matches);
      },
      onErr: (error, stack) => Err(error, stack),
    );
  }
}
