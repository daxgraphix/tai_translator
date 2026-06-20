import 'package:isar/isar.dart';

part 'favorite_model.g.dart';

/// Isar collection: Favorites (saved words/phrases for quick recall).
@collection
class FavoriteModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String word; // source word/phrase, used as the de-dup key

  late String translation;
  late String sourceLanguage;
  late String targetLanguage;
  late DateTime createdAt;
}
