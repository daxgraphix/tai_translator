import 'package:isar/isar.dart';

part 'learning_progress_model.g.dart';

/// Tracks daily-engagement style progress (streaks, quiz scores) per the
/// spec's Learning Module: "Purpose: Increase daily engagement."
@collection
class LearningProgressModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late DateTime day; // normalized to midnight, one row per day

  int wordsLearned = 0;
  int quizzesCompleted = 0;
  int quizCorrectAnswers = 0;
  int quizTotalAnswers = 0;
}
