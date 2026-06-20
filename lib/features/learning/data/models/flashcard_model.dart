import 'package:isar/isar.dart';

part 'flashcard_model.g.dart';

/// Isar collection backing the Learning Module's Flashcards & Daily
/// Word/Phrase features.
@collection
class FlashcardModel {
  Id id = Isar.autoIncrement;

  late String front; // e.g. English word ("Teacher")
  late String back; // e.g. Swahili translation ("Mwalimu")
  late String category; // 'word' | 'phrase'

  /// Simple spaced-repetition style counters.
  int timesReviewed = 0;
  int timesCorrect = 0;
  DateTime? lastReviewedAt;
}
