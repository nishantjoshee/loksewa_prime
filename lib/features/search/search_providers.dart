import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/current_affair.dart';
import '../../data/repository/content_repo.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider<List<CurrentAffair>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];
  final repo = ref.watch(contentRepositoryProvider);
  final result = await repo.search(query);
  return result.fold(
    onOk: (entries) => entries,
    onErr: (error, _) => throw error,
  );
});
