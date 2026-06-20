import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/translate/data/models/translation_history_model.dart';
import '../../features/dictionary/data/models/dictionary_entry_model.dart';
import '../../features/dictionary/data/models/saved_phrase_model.dart';
import '../../features/favorites/data/models/favorite_model.dart';
import '../../features/learning/data/models/flashcard_model.dart';
import '../../features/learning/data/models/learning_progress_model.dart';

/// Owns the single Isar instance for the whole app. Isar (not SQLite) was
/// chosen for offline speed and strong query performance on low-end
/// Android devices — see spec: Local Data Layer.
class IsarService {
  static Isar? _instance;

  static Future<Isar> open() async {
    if (_instance != null) return _instance!;

    final dir = await getApplicationDocumentsDirectory();
    _instance = await Isar.open(
      [
        TranslationHistoryModelSchema,
        DictionaryEntryModelSchema,
        SavedPhraseModelSchema,
        FavoriteModelSchema,
        FlashcardModelSchema,
        LearningProgressModelSchema,
      ],
      directory: dir.path,
      inspector: false,
    );
    return _instance!;
  }

  static Isar get instance {
    final db = _instance;
    if (db == null) {
      throw StateError('IsarService.open() must be awaited before use (see main.dart).');
    }
    return db;
  }
}
