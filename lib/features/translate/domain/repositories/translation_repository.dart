import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/translation_result.dart';

abstract class TranslationRepository {
  /// Runs the full pipeline: language detection is assumed already known
  /// (source/target passed explicitly), then Offline Engine vs Online
  /// Engine per connectivity — see spec: Translation Pipeline.
  Future<Either<Failure, TranslationResult>> translate({
    required String text,
    required String sourceLang,
    required String targetLang,
  });

  Future<void> saveToHistory(TranslationResult result);
  Stream<List<TranslationHistoryEntry>> watchHistory();
  Future<void> clearHistory();
  Future<void> deleteHistoryItem(int id);
}

/// Lightweight read model returned to the presentation layer so it never
/// has to import the Isar collection type directly.
class TranslationHistoryEntry {
  final int id;
  final String sourceText;
  final String translatedText;
  final String sourceLanguage;
  final String targetLanguage;
  final DateTime createdAt;
  final bool wasOnline;

  const TranslationHistoryEntry({
    required this.id,
    required this.sourceText,
    required this.translatedText,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.createdAt,
    required this.wasOnline,
  });
}
