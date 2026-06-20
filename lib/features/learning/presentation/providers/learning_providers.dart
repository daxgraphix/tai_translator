import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../../app/providers/core_providers.dart';
import '../../../dictionary/data/models/dictionary_entry_model.dart';
import '../../../dictionary/presentation/providers/dictionary_providers.dart';
import '../../data/models/flashcard_model.dart';
import '../../data/models/learning_progress_model.dart';

/// Deterministic "Daily Word" / "Daily Phrase" — same word all day for
/// every user, rotates daily, no server needed (spec: Learning Module).
final dailyWordProvider = FutureProvider<DictionaryEntryModel?>((ref) async {
  final isar = ref.watch(isarProvider);
  final count = await isar.dictionaryEntryModels.count();
  if (count == 0) return null;
  final dayIndex = DateTime.now().difference(DateTime(2026, 1, 1)).inDays;
  final index = dayIndex % count;
  return isar.dictionaryEntryModels.where().offset(index).limit(1).findFirst();
});

class LearningRepository {
  final Isar isar;
  LearningRepository(this.isar);

  /// Seeds flashcards from the dictionary on first launch.
  Future<void> seedFlashcardsIfEmpty() async {
    final count = await isar.flashcardModels.count();
    if (count > 0) return;
    final words = await isar.dictionaryEntryModels.where().limit(200).findAll();
    final cards = words
        .map((w) => FlashcardModel()
          ..front = w.englishWord
          ..back = w.swahiliWord
          ..category = 'word')
        .toList();
    await isar.writeTxn(() async => isar.flashcardModels.putAll(cards));
  }

  Future<List<FlashcardModel>> deck({int limit = 20}) async {
    final now = DateTime.now();

    // Spaced Repetition (SRS) approach:
    // 1. Cards never reviewed
    // 2. Cards reviewed but with poor accuracy (timesCorrect / timesReviewed < 0.7)
    // 3. Cards not reviewed in the last 3 days
    final newCards = await isar.flashcardModels.filter().timesReviewedEqualTo(0).limit(limit).findAll();

    final struggleCards = await isar.flashcardModels
        .filter()
        .timesReviewedGreaterThan(0)
        .and()
        .lastReviewedAtLessThan(now.subtract(const Duration(days: 1)))
        .findAll();

    final filteredStruggle = struggleCards.where((c) {
      if (c.timesReviewed == 0) return true;
      return (c.timesCorrect / c.timesReviewed) < 0.8;
    }).toList();

    final result = <FlashcardModel>{...newCards, ...filteredStruggle}.toList();
    result.shuffle(Random());
    return result.take(limit).toList();
  }

  Future<void> recordReview(int cardId, bool wasCorrect) async {
    final card = await isar.flashcardModels.get(cardId);
    if (card == null) return;
    card.timesReviewed += 1;
    if (wasCorrect) card.timesCorrect += 1;
    card.lastReviewedAt = DateTime.now();
    await isar.writeTxn(() async => isar.flashcardModels.put(card));
    await _bumpToday(wordsLearned: wasCorrect ? 1 : 0);
  }

  Future<void> recordQuizResult({required int correct, required int total}) async {
    await _bumpToday(quizzesCompleted: 1, correctAnswers: correct, totalAnswers: total);
  }

  Future<void> _bumpToday({
    int wordsLearned = 0,
    int quizzesCompleted = 0,
    int correctAnswers = 0,
    int totalAnswers = 0,
  }) async {
    final today = DateTime.now();
    final normalized = DateTime(today.year, today.month, today.day);
    final existing =
        await isar.learningProgressModels.filter().dayEqualTo(normalized).findFirst();

    final progress = existing ?? (LearningProgressModel()..day = normalized);
    progress.wordsLearned += wordsLearned;
    progress.quizzesCompleted += quizzesCompleted;
    progress.quizCorrectAnswers += correctAnswers;
    progress.quizTotalAnswers += totalAnswers;

    await isar.writeTxn(() async => isar.learningProgressModels.put(progress));
  }

  Stream<LearningProgressModel?> watchTodayProgress() {
    final today = DateTime.now();
    final normalized = DateTime(today.year, today.month, today.day);
    return isar.learningProgressModels
        .filter()
        .dayEqualTo(normalized)
        .watch(fireImmediately: true)
        .map((list) => list.isEmpty ? null : list.first);
  }
}

final learningRepositoryProvider = Provider<LearningRepository>((ref) {
  return LearningRepository(ref.watch(isarProvider));
});

final flashcardDeckProvider = FutureProvider<List<FlashcardModel>>((ref) {
  return ref.watch(learningRepositoryProvider).deck();
});

final todayProgressProvider = StreamProvider((ref) {
  return ref.watch(learningRepositoryProvider).watchTodayProgress();
});

/// Generates a 4-option multiple-choice quiz from the dictionary.
class QuizQuestion {
  final DictionaryEntryModel correctEntry;
  final List<String> options;
  final String correctAnswer;
  QuizQuestion({required this.correctEntry, required this.options, required this.correctAnswer});
}

final quizQuestionsProvider = FutureProvider<List<QuizQuestion>>((ref) async {
  final dictSource = ref.watch(dictionaryLocalSourceProvider);
  final all = await dictSource.isar.dictionaryEntryModels.where().findAll();
  if (all.length < 4) return [];

  final random = Random();
  final shuffled = List<DictionaryEntryModel>.from(all)..shuffle(random);
  final questions = <QuizQuestion>[];

  for (final entry in shuffled.take(10)) {
    final distractors = (List<DictionaryEntryModel>.from(all)..shuffle(random))
        .where((e) => e.id != entry.id)
        .take(3)
        .map((e) => e.swahiliWord)
        .toList();
    final options = [entry.swahiliWord, ...distractors]..shuffle(random);
    questions.add(QuizQuestion(correctEntry: entry, options: options, correctAnswer: entry.swahiliWord));
  }
  return questions;
});
