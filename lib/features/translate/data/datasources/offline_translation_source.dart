import '../../../../core/errors/exceptions.dart';
import '../../../dictionary/data/datasources/dictionary_local_source.dart';
import '../../domain/entities/translation_result.dart';

/// The "Offline Engine" from the spec's Translation Pipeline. It tries,
/// in order:
///   1. Exact phrase match (Phrase Database — greetings, travel, etc.)
///   2. Exact dictionary word match
///   3. Rule-based translation (tokenize the sentence, translate each
///      known word/stem via the dictionary, naively handle plural -s).
///
/// This never touches the network and is built to respond well under the
/// spec's <100ms offline budget for short inputs.
class OfflineTranslationSource {
  final DictionaryLocalSource dictionarySource;

  OfflineTranslationSource(this.dictionarySource);

  Future<TranslationResult> translate({
    required String text,
    required String sourceLang,
    required String targetLang,
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      throw OfflineDataException('Nothing to translate.');
    }

    // 1. Exact phrase match
    final phraseMatch = dictionarySource.findExactPhrase(
      text: trimmed,
      sourceLang: sourceLang,
      targetLang: targetLang,
    );
    if (phraseMatch != null) {
      return TranslationResult(
        sourceText: trimmed,
        translatedText: phraseMatch,
        sourceLanguage: sourceLang,
        targetLanguage: targetLang,
        engine: TranslationEngine.offlinePhrase,
      );
    }

    // 2. Exact single-word dictionary match
    if (!trimmed.contains(' ')) {
      final wordMatch = dictionarySource.findExactWord(
        word: trimmed,
        sourceLang: sourceLang,
        targetLang: targetLang,
      );
      if (wordMatch != null) {
        return TranslationResult(
          sourceText: trimmed,
          translatedText: wordMatch,
          sourceLanguage: sourceLang,
          targetLanguage: targetLang,
          engine: TranslationEngine.offlineDictionary,
        );
      }
    }

      // 3. Rule-based: translate word-by-word, falling back to the original
    //    token (with naive plural handling) when a word is unknown.
    final tokens = _splitWithDelimiters(trimmed, RegExp(r'(\s+)'));
    final translatedTokens = tokens.map((token) {
      if (token.isEmpty) return '';
      if (RegExp(r'^\s+$').hasMatch(token)) return token;

      final cleaned = token.replaceAll(RegExp(r'[^\w\u00C0-\u024F]'), '');
      final punctuation = token.replaceAll(cleaned, '');
      if (cleaned.isEmpty) return token;

      var lookup = cleaned.toLowerCase();

      // --- Improved Plural Handling ---

      // 1. English -> Swahili Plural
      if (sourceLang == 'en' && lookup.endsWith('s') && lookup.length > 3) {
        final singular = lookup.substring(0, lookup.length - 1);
        final swSingular = dictionarySource.findExactWord(
          word: singular,
          sourceLang: sourceLang,
          targetLang: targetLang,
        );
        if (swSingular != null) {
          final swPlural = _applySwahiliPlural(swSingular);
          final restored = _restoreCase(token, swPlural);
          return restored + punctuation;
        }
      }

      // 2. Swahili -> English Plural
      if (sourceLang == 'sw') {
        // --- Standard Lookup first ---
        final match = dictionarySource.findExactWord(
          word: lookup,
          sourceLang: sourceLang,
          targetLang: targetLang,
        );
        if (match != null) {
          return _restoreCase(token, match) + punctuation;
        }

        // Try de-pluralizing Swahili
        final stem = _getSwahiliSingularStem(lookup);
        if (stem != null && stem != lookup) {
          final enSingular = dictionarySource.findExactWord(
            word: stem,
            sourceLang: sourceLang,
            targetLang: targetLang,
          );
          if (enSingular != null) {
            final restored = _restoreCase(token, '${enSingular}s');
            return restored + punctuation;
          }
        }
      } else {
        // --- Standard Lookup for non-swahili source ---
        final match = dictionarySource.findExactWord(
          word: lookup,
          sourceLang: sourceLang,
          targetLang: targetLang,
        );
        if (match != null) {
          return _restoreCase(token, match) + punctuation;
        }
      }

      return token; // unknown word: leave as-is
    }).join();

    if (translatedTokens.trim().isEmpty || translatedTokens.trim() == trimmed) {
      throw OfflineDataException(
        'No offline match for "$trimmed". Connect to the internet for AI translation.',
      );
    }

    return TranslationResult(
      sourceText: trimmed,
      translatedText: translatedTokens.trim(),
      sourceLanguage: sourceLang,
      targetLanguage: targetLang,
      engine: TranslationEngine.offlineRuleBased,
    );
  }

  /// Naive Swahili plural rules based on noun classes (prefix-based).
  String _applySwahiliPlural(String singular) {
    final s = singular.toLowerCase();
    if (s.startsWith('mwana')) return 'wana${singular.substring(5)}';
    if (s.startsWith('ki')) return 'vi${singular.substring(2)}';
    if (s.startsWith('m')) {
      // Distinction between M/WA (people) and M/MI (objects) is tricky without tags.
      // Default to WA for common people nouns, MI for others.
      // This is a heuristic.
      final peopleStems = ['tu', 'toto', 'anafunzi', 'alimu', 'ke', 'ume', 'ganga', 'geni'];
      if (peopleStems.any((stem) => s.substring(1).startsWith(stem))) {
        return 'wa${singular.substring(1)}';
      }
      return 'mi${singular.substring(1)}';
    }
    if (s.startsWith('ji')) return 'ma${singular.substring(2)}';
    if (s.startsWith('u')) return 'ma${singular.substring(1)}';
    return singular; // Many nouns (N-class) don't change
  }

  /// Attempts to find the singular stem of a plural Swahili word.
  String? _getSwahiliSingularStem(String plural) {
    if (plural.length <= 2) return null;
    if (plural.startsWith('wana')) return 'mwana${plural.substring(4)}';
    if (plural.startsWith('wa')) return 'm${plural.substring(2)}';
    if (plural.startsWith('vi')) return 'ki${plural.substring(2)}';
    if (plural.startsWith('mi')) return 'm${plural.substring(2)}';
    if (plural.startsWith('ma')) {
      // Try replacing 'ma' with 'ji' or just removing 'ma' (ji-ma or u-ma class)
      // For this engine, we'll try 'ji' first as it's common for nouns like 'jicho' -> 'macho'
      return 'ji${plural.substring(2)}';
    }
    return null;
  }

  String _restoreCase(String original, String translated) {
    if (original.isEmpty || translated.isEmpty) return translated;

    // Check if ALL UPPER CASE
    if (original == original.toUpperCase() &&
        original != original.toLowerCase()) {
      return translated.toUpperCase();
    }

    // Check if Sentence case or Title Case
    if (original[0] == original[0].toUpperCase() &&
        original[0] != original[0].toLowerCase()) {
      return '${translated[0].toUpperCase()}${translated.substring(1).toLowerCase()}';
    }

    return translated.toLowerCase();
  }

  /// Splits a string but keeps the delimiters in the resulting list.
  List<String> _splitWithDelimiters(String input, RegExp pattern) {
    final matches = pattern.allMatches(input);
    if (matches.isEmpty) return [input];

    final result = <String>[];
    int start = 0;
    for (final match in matches) {
      if (match.start > start) {
        result.add(input.substring(start, match.start));
      }
      result.add(input.substring(match.start, match.end));
      start = match.end;
    }
    if (start < input.length) {
      result.add(input.substring(start));
    }
    return result;
  }
}
