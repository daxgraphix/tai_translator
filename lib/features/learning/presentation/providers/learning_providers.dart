import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../../app/providers/core_providers.dart';
import '../../../dictionary/data/models/dictionary_entry_model.dart';
import '../../../dictionary/data/models/saved_phrase_model.dart';
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

final dailyPhraseProvider = FutureProvider<SavedPhraseModel?>((ref) async {
  final isar = ref.watch(isarProvider);
  final count = await isar.savedPhraseModels.count();
  if (count == 0) return null;
  final dayIndex = DateTime.now().difference(DateTime(2026, 1, 1)).inDays;
  final index = dayIndex % count;
  return isar.savedPhraseModels.where().offset(index).limit(1).findFirst();
});

class LearningRepository {
  final Isar isar;
  LearningRepository(this.isar);

  /// Seeds flashcards from the dictionary and phrases on first launch.
  Future<void> seedFlashcardsIfEmpty() async {
    final count = await isar.flashcardModels.count();
    if (count > 0) return;

    // Seed from Dictionary (Words)
    final words = await isar.dictionaryEntryModels.where().limit(200).findAll();
    final wordCards = words
        .map((w) => FlashcardModel()
          ..front = w.englishWord
          ..back = w.swahiliWord
          ..category = 'word')
        .toList();

    // Seed from Phrases
    final phrases = await isar.savedPhraseModels.where().limit(100).findAll();
    final phraseCards = phrases
        .map((p) => FlashcardModel()
          ..front = p.englishPhrase
          ..back = p.swahiliPhrase
          ..category = 'phrase')
        .toList();

    await isar.writeTxn(() async {
      await isar.flashcardModels.putAll(wordCards);
      await isar.flashcardModels.putAll(phraseCards);
    });
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

/// Generates a 10-question multiple-choice quiz.
/// Randomly mixes words from the dictionary and common phrases.
final quizQuestionsProvider = FutureProvider<List<QuizQuestion>>((ref) async {
  final isar = ref.watch(isarProvider);
  
  final words = await isar.dictionaryEntryModels.where().limit(200).findAll();
  final phrases = await isar.savedPhraseModels.where().limit(100).findAll();

  if (words.length + phrases.length < 5) return [];

  final random = Random();
  final questions = <QuizQuestion>[];

  // Combine sources into a common format for picking questions
  final pool = [
    ...words.map((w) => (front: w.englishWord, back: w.swahiliWord, type: 'word')),
    ...phrases.map((p) => (front: p.englishPhrase, back: p.swahiliPhrase, type: 'phrase')),
  ];
  
  final shuffledPool = List.from(pool)..shuffle(random);
  
  for (final item in shuffledPool.take(10)) {
    // Get 3 distractors of the same type if possible, else from general pool
    final sameTypeDistractors = pool
        .where((e) => e.type == item.type && e.front != item.front)
        .toList();
    
    final distractorSource = sameTypeDistractors.length >= 3 ? sameTypeDistractors : pool;
    
    final distractors = <String>[];
    for (final d in (List.from(distractorSource)..shuffle(random))
        .where((e) => e.front != item.front)
        .take(3)) {
      distractors.add(d.back);
    }

    // If we still don't have enough distractors, just grab anything unique
    if (distractors.length < 3) {
      for (final d in pool
          .where((e) => e.front != item.front && !distractors.contains(e.back))
          .take(3 - distractors.length)) {
        distractors.add(d.back);
      }
    }

    final List<String> options = [item.back, ...distractors]..shuffle(random);
    
    // We reuse DictionaryEntryModel for the correctEntry if it's a word, 
    // but QuizQuestion needs to be more generic if we want to support both easily.
    // Let's modify QuizQuestion to be more flexible.
    questions.add(QuizQuestion(
      question: item.front,
      options: options,
      correctAnswer: item.back,
    ));
  }
  return questions;
});

class QuizQuestion {
  final String question;
  final List<String> options;
  final String correctAnswer;
  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });
}
