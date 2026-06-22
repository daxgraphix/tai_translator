/// Engine that ultimately resolved a translation request.
enum TranslationEngine { offlineDictionary, offlinePhrase, offlineRuleBased, online, literal }

class TranslationResult {
  final String sourceText;
  final String translatedText;
  final String sourceLanguage;
  final String targetLanguage;
  final TranslationEngine engine;

  const TranslationResult({
    required this.sourceText,
    required this.translatedText,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.engine,
  });

  bool get wasOnline => engine == TranslationEngine.online;
  bool get isLiteral => engine == TranslationEngine.literal;
}
