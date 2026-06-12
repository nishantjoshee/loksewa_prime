import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants.dart';
import '../../core/error_reporter.dart';

final readEntriesProvider =
    StateNotifierProvider<ReadEntriesNotifier, Set<String>>((ref) {
      return ReadEntriesNotifier();
    });

class ReadEntriesNotifier extends StateNotifier<Set<String>> {
  ReadEntriesNotifier() : super({}) {
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ids = prefs.getStringList(AppConstants.readKey) ?? [];
      state = ids.toSet();
    } catch (e, stack) {
      ErrorReporter.report(e, stack: stack);
    }
  }

  Future<void> markRead(String id) async {
    if (state.contains(id)) return;
    final updated = {...state, id};
    state = updated;
    await _persist();
  }

  Future<void> unmarkRead(String id) async {
    if (!state.contains(id)) return;
    final updated = {...state};
    updated.remove(id);
    state = updated;
    await _persist();
  }

  bool isRead(String id) => state.contains(id);

  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(AppConstants.readKey, state.toList());
    } catch (e, stack) {
      ErrorReporter.report(e, stack: stack);
    }
  }
}
