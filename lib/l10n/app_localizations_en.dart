// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'TAI Translator';

  @override
  String get appTagline => 'Translate. Learn. Connect.';

  @override
  String get translate => 'Translate';

  @override
  String get dictionary => 'Dictionary';

  @override
  String get learn => 'Learn';

  @override
  String get settings => 'Settings';

  @override
  String get history => 'History';

  @override
  String get favorites => 'Favorites';

  @override
  String get voiceNotAvailable =>
      'Voice input is not available on this device.';

  @override
  String get listening => 'Listening...';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get appearance => 'Appearance';

  @override
  String get systemDefault => 'System default';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get translation => 'Translation';

  @override
  String get onlineTranslation => 'AI translation when online';

  @override
  String get onlineTranslationDesc =>
      'Uses Groq Cloud for higher-quality translations when connected. Falls back to the offline engine automatically.';

  @override
  String get groqApiKey => 'Groq API key';

  @override
  String get notSet => 'Not set';

  @override
  String get apiKeySaved => 'API key saved';

  @override
  String get voice => 'Voice';

  @override
  String get speechRate => 'Speech rate';

  @override
  String get pitch => 'Pitch';

  @override
  String get privacyAbout => 'Privacy & About';

  @override
  String get noTracking => 'No accounts, no tracking';

  @override
  String get privacyDesc =>
      'TAI Translator collects no personal data and has no ads or analytics SDKs. Internet is only used, optionally, for AI-enhanced translation.';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get searchHint => 'Search English or Swahili words...';

  @override
  String get dictionaryEmptyStateTitle => 'Search the offline dictionary';

  @override
  String get dictionaryEmptyStateSubtitle =>
      'Exact, partial, and fuzzy matches — works fully offline.';

  @override
  String get noMatchesFound => 'No matches found';

  @override
  String get noMatchesSubtitle => 'Try a different spelling or a shorter word.';

  @override
  String get clearHistory => 'Clear history';

  @override
  String get clearHistoryConfirmTitle => 'Clear all history?';

  @override
  String get clearHistoryConfirmContent => 'This cannot be undone.';

  @override
  String get clear => 'Clear';

  @override
  String get noHistoryTitle => 'No translations yet';

  @override
  String get noHistorySubtitle => 'Everything you translate will show up here.';

  @override
  String get noFavoritesTitle => 'No favorites yet';

  @override
  String get noFavoritesSubtitle =>
      'Tap the heart icon on any translation or word to save it here.';

  @override
  String get dailyWord => 'Daily Word';

  @override
  String get dailyPhrase => 'Daily Phrase';

  @override
  String get noWordsAvailable => 'No words available yet.';

  @override
  String get noPhrasesAvailable => 'No phrases available yet.';

  @override
  String get todaysProgress => 'Today\'s Progress';

  @override
  String get wordsLearned => 'Words';

  @override
  String get quizzesCompleted => 'Quizzes';

  @override
  String get accuracy => 'Accuracy';

  @override
  String get practice => 'Practice';

  @override
  String get flashcards => 'Flashcards';

  @override
  String get flashcardsSubtitle => 'Flip through words and their translations';

  @override
  String get quizMode => 'Quiz Mode';

  @override
  String get quizModeSubtitle => 'Multiple choice — test your vocabulary';

  @override
  String get noFlashcardsTitle => 'No flashcards yet';

  @override
  String get noFlashcardsSubtitle =>
      'Search a few words in the Dictionary tab first.';

  @override
  String get deckComplete => 'Deck complete!';

  @override
  String get restart => 'Restart';

  @override
  String get swahili => 'Swahili';

  @override
  String get englishTapToFlip => 'English — tap to flip';

  @override
  String get listen => 'Listen';

  @override
  String get didntKnow => 'Didn\'t know';

  @override
  String get knewIt => 'Knew it';

  @override
  String get notEnoughWordsTitle => 'Not enough words yet';

  @override
  String get notEnoughWordsSubtitle =>
      'Search a few more words in the Dictionary tab first.';

  @override
  String questionCount(int index, int total) {
    return 'Question $index of $total';
  }

  @override
  String quizQuestion(String word) {
    return 'What is the Swahili word for \"$word\"?';
  }

  @override
  String get next => 'Next';

  @override
  String scoreResult(int correct, int total) {
    return '$correct / $total correct';
  }

  @override
  String get tryAgain => 'Try Again';

  @override
  String get word => 'Word';

  @override
  String get wordNotFound => 'Word not found.';

  @override
  String get definition => 'Definition';

  @override
  String get examples => 'Examples';

  @override
  String get swapLanguages => 'Swap languages';

  @override
  String get enterText => 'Enter text...';

  @override
  String get camera => 'Camera';

  @override
  String get paste => 'Paste';

  @override
  String get aiOnline => 'AI · Online';

  @override
  String get offline => 'Offline';

  @override
  String get english => 'English';

  @override
  String get translateFromImage => 'Translate from Image';

  @override
  String get gallery => 'Gallery';

  @override
  String get extractedText => 'Extracted text';

  @override
  String get noTextFound => 'No text found.';

  @override
  String get useThisText => 'Use this text';

  @override
  String get ocrError => 'Could not read text from this image.';

  @override
  String get share => 'Share';

  @override
  String get wordBook => 'Word Book';

  @override
  String get wordBookSubtitle => 'Browse 400+ common words';

  @override
  String get viewAll => 'View All';
}
