import 'package:isar/isar.dart';

part 'dictionary_entry_model.g.dart';

/// Isar collection backing the Dictionary Module. Seeded once on first
/// launch from assets/data/dictionary_seed.json (see core/storage and
/// data/local/seed).
@collection
class DictionaryEntryModel {
  Id id = Isar.autoIncrement;

  @Index()
  String englishWord;

  @Index()
  String swahiliWord;

  String partOfSpeech; // noun, verb, adjective, phrase...
  String definition;

  List<String> examples;

  String? pronunciation;

  DictionaryEntryModel({
    this.id = Isar.autoIncrement,
    this.englishWord = '',
    this.swahiliWord = '',
    this.partOfSpeech = '',
    this.definition = '',
    this.examples = const [],
    this.pronunciation,
  });
}
