import 'package:dartz/dartz.dart';
import 'package:isar/isar.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/translation_result.dart';
import '../../domain/repositories/translation_repository.dart';
import '../datasources/groq_translation_source.dart';
import '../datasources/offline_translation_source.dart';
import '../models/translation_history_model.dart';

/// TranslationRepository = TranslationCoordinator from the spec:
///
///   if (internetAvailable && onlineEnabled) { useGroq() } else { useOffline() }
///
/// with a graceful fallback to the offline engine if the online call
/// fails for any reason (timeout, no API key, server error).
class TranslationRepositoryImpl implements TranslationRepository {
  final OfflineTranslationSource offlineSource;
  final GroqTranslationSource? onlineSource;
  final NetworkInfo networkInfo;
  final Isar isar;
  final bool onlineEnabled;

  TranslationRepositoryImpl({
    required this.offlineSource,
    required this.onlineSource,
    required this.networkInfo,
    required this.isar,
    required this.onlineEnabled,
  });

  @override
  Future<Either<Failure, TranslationResult>> translate({
    required String text,
    required String sourceLang,
    required String targetLang,
  }) async {
    // 1. Check Cache first
    final cached = await isar.translationHistoryModels
        .where()
        .sourceTextEqualTo(text)
        .filter()
        .sourceLanguageEqualTo(sourceLang)
        .targetLanguageEqualTo(targetLang)
        .sortByCreatedAtDesc()
        .findFirst();

    if (cached != null) {
      return Right(TranslationResult(
        sourceText: cached.sourceText,
        translatedText: cached.translatedText,
        sourceLanguage: cached.sourceLanguage,
        targetLanguage: cached.targetLanguage,
        engine: cached.wasOnline ? TranslationEngine.online : TranslationEngine.offlinePhrase,
      ));
    }

    final connected = await networkInfo.isConnected;

    if (connected && onlineEnabled && onlineSource != null) {
      try {
        final result = await onlineSource!.translate(
          text: text,
          sourceLang: sourceLang,
          targetLang: targetLang,
        );
        return Right(result);
      } catch (_) {
        // Fall through to offline engine — never leave the user stranded.
      }
    }

    try {
      final result = await offlineSource.translate(
        text: text,
        sourceLang: sourceLang,
        targetLang: targetLang,
      );
      return Right(result);
    } on OfflineDataException catch (e) {
      return Left(OfflineDataFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<void> saveToHistory(TranslationResult result) async {
    final model = TranslationHistoryModel()
      ..sourceText = result.sourceText
      ..translatedText = result.translatedText
      ..sourceLanguage = result.sourceLanguage
      ..targetLanguage = result.targetLanguage
      ..createdAt = DateTime.now()
      ..wasOnline = result.wasOnline;

    await isar.writeTxn(() async {
      await isar.translationHistoryModels.put(model);
    });
  }

  @override
  Stream<List<TranslationHistoryEntry>> watchHistory() {
    return isar.translationHistoryModels
        .where()
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true)
        .map((list) => list
            .map((m) => TranslationHistoryEntry(
                  id: m.id,
                  sourceText: m.sourceText,
                  translatedText: m.translatedText,
                  sourceLanguage: m.sourceLanguage,
                  targetLanguage: m.targetLanguage,
                  createdAt: m.createdAt,
                  wasOnline: m.wasOnline,
                ))
            .toList());
  }

  @override
  Future<void> clearHistory() async {
    await isar.writeTxn(() async {
      await isar.translationHistoryModels.clear();
    });
  }

  @override
  Future<void> deleteHistoryItem(int id) async {
    await isar.writeTxn(() async {
      await isar.translationHistoryModels.delete(id);
    });
  }
}
