/// Global, app-wide constants. Keep this free of any UI/business logic.
class AppConstants {
  AppConstants._();

  static const String appName = 'TAI English Swahili Translator';
  static const String appTagline = 'Translate. Learn. Connect.';

  // Supported languages (Community Edition: EN <-> SW)
  static const String langEnglish = 'en';
  static const String langSwahili = 'sw';
  static const Map<String, String> languageNames = {
    langEnglish: 'English',
    langSwahili: 'Swahili',
  };

  // Performance targets (see spec: Performance Targets)
  static const Duration offlineTranslationBudget = Duration(milliseconds: 100);
  static const Duration onlineTranslationBudget = Duration(seconds: 2);

  // Online AI translation provider
  static const String groqBaseUrl = 'https://api.groq.com/openai/v1';
  static const String groqModel = 'llama-3.1-8b-instant';
  // Hardcoded API Key as per user request to bypass manual setup
  static const String defaultGroqApiKey = 'gsk_y6e9N7qYp3bW2mX1zR4v5T6u7i8o9p0a1s2d3f4g5h6j7k8l9';

  // Storage keys
  static const String prefThemeMode = 'pref_theme_mode';
  static const String prefSourceLang = 'pref_source_lang';
  static const String prefTargetLang = 'pref_target_lang';
  static const String prefVoiceSpeed = 'pref_voice_speed';
  static const String prefVoicePitch = 'pref_voice_pitch';
  static const String prefGroqApiKey = 'pref_groq_api_key';
  static const String prefOnlineTranslationEnabled = 'pref_online_translation_enabled';

  // Misc
  static const int maxHistoryItems = 500;
  static const int dictionarySearchLimit = 50;
}

/// Phrase categories used by the offline Phrase Database module.
enum PhraseCategory { greetings, travel, education, business, healthcare }

extension PhraseCategoryLabel on PhraseCategory {
  String get label {
    switch (this) {
      case PhraseCategory.greetings:
        return 'Greetings';
      case PhraseCategory.travel:
        return 'Travel';
      case PhraseCategory.education:
        return 'Education';
      case PhraseCategory.business:
        return 'Business';
      case PhraseCategory.healthcare:
        return 'Healthcare';
    }
  }
}
