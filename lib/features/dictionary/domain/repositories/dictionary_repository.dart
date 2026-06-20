import '../../data/models/dictionary_entry_model.dart';
import '../../data/models/saved_phrase_model.dart';

abstract class DictionaryRepository {
  Future<List<DictionaryEntryModel>> search(String query);
  Future<List<DictionaryEntryModel>> getAll();
  Future<DictionaryEntryModel?> getById(int id);
  Future<List<SavedPhraseModel>> phrasesByCategory(String category);
}
