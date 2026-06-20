import 'package:isar/isar.dart';

part 'saved_phrase_model.g.dart';

/// Isar collection: SavedPhrases (Phrase Database — greetings, travel,
/// education, business, healthcare). Seeded on first launch; user-saved
/// custom phrases are appended at runtime.
@collection
class SavedPhraseModel {
  Id id = Isar.autoIncrement;

  @Index()
  String category; // matches PhraseCategory.name

  @Index()
  String englishPhrase;

  String swahiliPhrase;

  bool isUserAdded = false;

  SavedPhraseModel({
    this.id = Isar.autoIncrement,
    this.category = '',
    this.englishPhrase = '',
    this.swahiliPhrase = '',
    this.isUserAdded = false,
  });
}
