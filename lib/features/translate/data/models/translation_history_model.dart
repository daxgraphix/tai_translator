import 'package:isar/isar.dart';

part 'translation_history_model.g.dart';

/// Isar collection: TranslationHistory (see spec: Local Data Layer).
@collection
class TranslationHistoryModel {
  Id id = Isar.autoIncrement;

  @Index()
  late String sourceText;
  
  late String translatedText;

  @Index()
  late String sourceLanguage;

  @Index()
  late String targetLanguage;

  @Index()
  late DateTime createdAt;

  /// True if this translation came from the Groq online engine,
  /// false if it was resolved offline (dictionary/phrase/rule-based).
  bool wasOnline = false;
}
