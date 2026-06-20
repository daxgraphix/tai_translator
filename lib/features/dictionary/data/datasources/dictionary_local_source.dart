import 'package:isar/isar.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utilities/fuzzy_match.dart';
import '../../../../data/local/seed/dictionary_seed.dart';
import '../../../../data/local/seed/phrases_seed.dart';
import '../models/dictionary_entry_model.dart';
import '../models/saved_phrase_model.dart';

/// All offline dictionary/phrase lookups go through here. Backs both the
/// Dictionary Module's search engine (exact / partial / fuzzy) and the
/// offline translation engine's word & phrase lookups.
class DictionaryLocalSource {
  final Isar isar;
  DictionaryLocalSource(this.isar);

  /// Seeds the dictionary + phrase collections on first launch only.
  Future<void> seedIfEmpty() async {
    final wordCount = await isar.dictionaryEntryModels.count();
    if (wordCount == 0) {
      final entries = dictionarySeedData.map((row) {
        return DictionaryEntryModel()
          ..englishWord = row[0]
          ..swahiliWord = row[1]
          ..partOfSpeech = row[2]
          ..definition = row[3];
      }).toList();
      await isar.writeTxn(() async {
        await isar.dictionaryEntryModels.putAll(entries);
      });
    }

    final phraseCount = await isar.savedPhraseModels.count();
    if (phraseCount == 0) {
      final phrases = phrasesSeedData.map((row) {
        final category = row[0] as PhraseCategory;
        return SavedPhraseModel()
          ..category = category.name
          ..englishPhrase = row[1]
          ..swahiliPhrase = row[2]
          ..isUserAdded = false;
      }).toList();
      await isar.writeTxn(() async {
        await isar.savedPhraseModels.putAll(phrases);
      });
    }
  }

  // ---------------- Translation-engine lookups ----------------

  String? findExactWord({
    required String word,
    required String sourceLang,
    required String targetLang,
  }) {
    final normalized = word.trim().toLowerCase();
    if (normalized.isEmpty) return null;

    DictionaryEntryModel? entry;
    if (sourceLang == AppConstants.langEnglish) {
      entry = isar.dictionaryEntryModels
          .filter()
          .englishWordEqualTo(normalized, caseSensitive: false)
          .findFirstSync();
      return entry?.swahiliWord;
    } else {
      entry = isar.dictionaryEntryModels
          .filter()
          .swahiliWordEqualTo(normalized, caseSensitive: false)
          .findFirstSync();
      return entry?.englishWord;
    }
  }

  String? findExactPhrase({
    required String text,
    required String sourceLang,
    required String targetLang,
  }) {
    final normalized = text.trim();
    if (sourceLang == AppConstants.langEnglish) {
      final phrase = isar.savedPhraseModels
          .filter()
          .englishPhraseEqualTo(normalized, caseSensitive: false)
          .findFirstSync();
      return phrase?.swahiliPhrase;
    } else {
      final phrase = isar.savedPhraseModels
          .filter()
          .swahiliPhraseEqualTo(normalized, caseSensitive: false)
          .findFirstSync();
      return phrase?.englishPhrase;
    }
  }

  // ---------------- Dictionary Module search engine ----------------

  /// Exact -> Partial -> Fuzzy, merged and de-duplicated, matching the
  /// spec's Search Engine section (e.g. "komputa" -> "computer").
  Future<List<DictionaryEntryModel>> search(String query, {int limit = 50}) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];

    final exact = await isar.dictionaryEntryModels
        .filter()
        .englishWordEqualTo(q, caseSensitive: false)
        .or()
        .swahiliWordEqualTo(q, caseSensitive: false)
        .findAll();

    final partial = await isar.dictionaryEntryModels
        .filter()
        .englishWordContains(q, caseSensitive: false)
        .or()
        .swahiliWordContains(q, caseSensitive: false)
        .limit(limit)
        .findAll();

    final merged = <int, DictionaryEntryModel>{};
    for (final e in [...exact, ...partial]) {
      merged[e.id] = e;
    }

    // Fuzzy: only bother if exact/partial came up short — keeps search snappy.
    if (merged.length < 5) {
      final all = await isar.dictionaryEntryModels.where().limit(2000).findAll();
      final scored = all
          .map((e) => (
                entry: e,
                score: [
                  similarity(q, e.englishWord),
                  similarity(q, e.swahiliWord),
                ].reduce((a, b) => a > b ? a : b),
              ))
          .where((s) => s.score >= 0.6)
          .toList()
        ..sort((a, b) => b.score.compareTo(a.score));

      for (final s in scored.take(limit)) {
        merged[s.entry.id] = s.entry;
      }
    }

    final results = merged.values.toList()
      ..sort((a, b) => a.englishWord.compareTo(b.englishWord));
    return results.take(limit).toList();
  }

  Future<DictionaryEntryModel?> getById(int id) => isar.dictionaryEntryModels.get(id);

  Future<List<SavedPhraseModel>> phrasesByCategory(String category) {
    return isar.savedPhraseModels.filter().categoryEqualTo(category).findAll();
  }

  Future<void> addCustomPhrase({
    required PhraseCategory category,
    required String english,
    required String swahili,
  }) async {
    final phrase = SavedPhraseModel()
      ..category = category.name
      ..englishPhrase = english
      ..swahiliPhrase = swahili
      ..isUserAdded = true;
    await isar.writeTxn(() async {
      await isar.savedPhraseModels.put(phrase);
    });
  }
}
