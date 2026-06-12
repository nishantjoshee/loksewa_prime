import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/current_affair.dart';
import '../../data/repository/content_repo.dart';

final detailProvider = FutureProvider.family<CurrentAffair?, String>((
  ref,
  entryId,
) async {
  final repo = ref.watch(contentRepositoryProvider);
  final result = await repo.loadEntry(entryId);
  return result.fold(onOk: (entry) => entry, onErr: (error, _) => throw error);
});
