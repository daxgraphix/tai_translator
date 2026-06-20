import '../../domain/repositories/dictionary_repository.dart';
import '../datasources/dictionary_local_source.dart';
import '../models/dictionary_entry_model.dart';
import '../models/saved_phrase_model.dart';

class DictionaryRepositoryImpl implements DictionaryRepository {
  final DictionaryLocalSource localSource;
  DictionaryRepositoryImpl(this.localSource);

  @override
  Future<List<DictionaryEntryModel>> search(String query) => localSource.search(query);

  @override
  Future<DictionaryEntryModel?> getById(int id) => localSource.getById(id);

  @override
  Future<List<SavedPhraseModel>> phrasesByCategory(String category) =>
      localSource.phrasesByCategory(category);
}
