import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/core_providers.dart';
import '../../data/datasources/dictionary_local_source.dart';
import '../../data/models/dictionary_entry_model.dart';
import '../../data/repositories/dictionary_repository_impl.dart';
import '../../domain/repositories/dictionary_repository.dart';

final dictionaryLocalSourceProvider = Provider<DictionaryLocalSource>((ref) {
  return DictionaryLocalSource(ref.watch(isarProvider));
});

final dictionaryRepositoryProvider = Provider<DictionaryRepository>((ref) {
  return DictionaryRepositoryImpl(ref.watch(dictionaryLocalSourceProvider));
});

final dictionarySearchQueryProvider = StateProvider<String>((ref) => '');

final dictionarySearchResultsProvider = FutureProvider<List<DictionaryEntryModel>>((ref) async {
  final query = ref.watch(dictionarySearchQueryProvider);
  if (query.trim().isEmpty) {
    return ref.watch(dictionaryRepositoryProvider).getAll();
  }
  return ref.watch(dictionaryRepositoryProvider).search(query);
});

final dictionaryEntryProvider =
    FutureProvider.family<DictionaryEntryModel?, int>((ref, id) async {
  return ref.watch(dictionaryRepositoryProvider).getById(id);
});
