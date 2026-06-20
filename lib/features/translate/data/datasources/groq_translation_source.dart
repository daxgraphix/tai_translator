import '../../../../core/services/groq_translation_service.dart';
import '../../domain/entities/translation_result.dart';

/// The "Online Engine" — only invoked by [TranslationCoordinator] when
/// connectivity is available and the user has opted in / configured a key
/// in Settings.
class GroqTranslationSource {
  final GroqTranslationService service;
  GroqTranslationSource(this.service);

  Future<TranslationResult> translate({
    required String text,
    required String sourceLang,
    required String targetLang,
  }) async {
    final translated = await service.translate(
      text: text,
      sourceLang: sourceLang,
      targetLang: targetLang,
    );
    return TranslationResult(
      sourceText: text,
      translatedText: translated,
      sourceLanguage: sourceLang,
      targetLanguage: targetLang,
      engine: TranslationEngine.online,
    );
  }
}
