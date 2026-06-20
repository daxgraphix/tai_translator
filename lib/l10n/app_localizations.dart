import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_sw.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('sw')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'TAI Translator'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Translate. Learn. Connect.'**
  String get appTagline;

  /// No description provided for @translate.
  ///
  /// In en, this message translates to:
  /// **'Translate'**
  String get translate;

  /// No description provided for @dictionary.
  ///
  /// In en, this message translates to:
  /// **'Dictionary'**
  String get dictionary;

  /// No description provided for @learn.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get learn;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @voiceNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Voice input is not available on this device.'**
  String get voiceNotAvailable;

  /// No description provided for @listening.
  ///
  /// In en, this message translates to:
  /// **'Listening...'**
  String get listening;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get systemDefault;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @translation.
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get translation;

  /// No description provided for @onlineTranslation.
  ///
  /// In en, this message translates to:
  /// **'AI translation when online'**
  String get onlineTranslation;

  /// No description provided for @onlineTranslationDesc.
  ///
  /// In en, this message translates to:
  /// **'Uses Groq Cloud for higher-quality translations when connected. Falls back to the offline engine automatically.'**
  String get onlineTranslationDesc;

  /// No description provided for @groqApiKey.
  ///
  /// In en, this message translates to:
  /// **'Groq API key'**
  String get groqApiKey;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @apiKeySaved.
  ///
  /// In en, this message translates to:
  /// **'API key saved'**
  String get apiKeySaved;

  /// No description provided for @voice.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get voice;

  /// No description provided for @speechRate.
  ///
  /// In en, this message translates to:
  /// **'Speech rate'**
  String get speechRate;

  /// No description provided for @pitch.
  ///
  /// In en, this message translates to:
  /// **'Pitch'**
  String get pitch;

  /// No description provided for @privacyAbout.
  ///
  /// In en, this message translates to:
  /// **'Privacy & About'**
  String get privacyAbout;

  /// No description provided for @noTracking.
  ///
  /// In en, this message translates to:
  /// **'No accounts, no tracking'**
  String get noTracking;

  /// No description provided for @privacyDesc.
  ///
  /// In en, this message translates to:
  /// **'TAI Translator collects no personal data and has no ads or analytics SDKs. Internet is only used, optionally, for AI-enhanced translation.'**
  String get privacyDesc;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search English or Swahili words...'**
  String get searchHint;

  /// No description provided for @dictionaryEmptyStateTitle.
  ///
  /// In en, this message translates to:
  /// **'Search the offline dictionary'**
  String get dictionaryEmptyStateTitle;

  /// No description provided for @dictionaryEmptyStateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Exact, partial, and fuzzy matches — works fully offline.'**
  String get dictionaryEmptyStateSubtitle;

  /// No description provided for @noMatchesFound.
  ///
  /// In en, this message translates to:
  /// **'No matches found'**
  String get noMatchesFound;

  /// No description provided for @noMatchesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try a different spelling or a shorter word.'**
  String get noMatchesSubtitle;

  /// No description provided for @clearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear history'**
  String get clearHistory;

  /// No description provided for @clearHistoryConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear all history?'**
  String get clearHistoryConfirmTitle;

  /// No description provided for @clearHistoryConfirmContent.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone.'**
  String get clearHistoryConfirmContent;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @noHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'No translations yet'**
  String get noHistoryTitle;

  /// No description provided for @noHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Everything you translate will show up here.'**
  String get noHistorySubtitle;

  /// No description provided for @noFavoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get noFavoritesTitle;

  /// No description provided for @noFavoritesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart icon on any translation or word to save it here.'**
  String get noFavoritesSubtitle;

  /// No description provided for @dailyWord.
  ///
  /// In en, this message translates to:
  /// **'Daily Word'**
  String get dailyWord;

  /// No description provided for @noWordsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No words available yet.'**
  String get noWordsAvailable;

  /// No description provided for @todaysProgress.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Progress'**
  String get todaysProgress;

  /// No description provided for @wordsLearned.
  ///
  /// In en, this message translates to:
  /// **'Words'**
  String get wordsLearned;

  /// No description provided for @quizzesCompleted.
  ///
  /// In en, this message translates to:
  /// **'Quizzes'**
  String get quizzesCompleted;

  /// No description provided for @accuracy.
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get accuracy;

  /// No description provided for @practice.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get practice;

  /// No description provided for @flashcards.
  ///
  /// In en, this message translates to:
  /// **'Flashcards'**
  String get flashcards;

  /// No description provided for @flashcardsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Flip through words and their translations'**
  String get flashcardsSubtitle;

  /// No description provided for @quizMode.
  ///
  /// In en, this message translates to:
  /// **'Quiz Mode'**
  String get quizMode;

  /// No description provided for @quizModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Multiple choice — test your vocabulary'**
  String get quizModeSubtitle;

  /// No description provided for @noFlashcardsTitle.
  ///
  /// In en, this message translates to:
  /// **'No flashcards yet'**
  String get noFlashcardsTitle;

  /// No description provided for @noFlashcardsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Search a few words in the Dictionary tab first.'**
  String get noFlashcardsSubtitle;

  /// No description provided for @deckComplete.
  ///
  /// In en, this message translates to:
  /// **'Deck complete!'**
  String get deckComplete;

  /// No description provided for @restart.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restart;

  /// No description provided for @swahili.
  ///
  /// In en, this message translates to:
  /// **'Swahili'**
  String get swahili;

  /// No description provided for @englishTapToFlip.
  ///
  /// In en, this message translates to:
  /// **'English — tap to flip'**
  String get englishTapToFlip;

  /// No description provided for @listen.
  ///
  /// In en, this message translates to:
  /// **'Listen'**
  String get listen;

  /// No description provided for @didntKnow.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t know'**
  String get didntKnow;

  /// No description provided for @knewIt.
  ///
  /// In en, this message translates to:
  /// **'Knew it'**
  String get knewIt;

  /// No description provided for @notEnoughWordsTitle.
  ///
  /// In en, this message translates to:
  /// **'Not enough words yet'**
  String get notEnoughWordsTitle;

  /// No description provided for @notEnoughWordsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Search a few more words in the Dictionary tab first.'**
  String get notEnoughWordsSubtitle;

  /// No description provided for @questionCount.
  ///
  /// In en, this message translates to:
  /// **'Question {index} of {total}'**
  String questionCount(int index, int total);

  /// No description provided for @quizQuestion.
  ///
  /// In en, this message translates to:
  /// **'What is the Swahili word for \"{word}\"?'**
  String quizQuestion(String word);

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @scoreResult.
  ///
  /// In en, this message translates to:
  /// **'{correct} / {total} correct'**
  String scoreResult(int correct, int total);

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @word.
  ///
  /// In en, this message translates to:
  /// **'Word'**
  String get word;

  /// No description provided for @wordNotFound.
  ///
  /// In en, this message translates to:
  /// **'Word not found.'**
  String get wordNotFound;

  /// No description provided for @definition.
  ///
  /// In en, this message translates to:
  /// **'Definition'**
  String get definition;

  /// No description provided for @examples.
  ///
  /// In en, this message translates to:
  /// **'Examples'**
  String get examples;

  /// No description provided for @swapLanguages.
  ///
  /// In en, this message translates to:
  /// **'Swap languages'**
  String get swapLanguages;

  /// No description provided for @enterText.
  ///
  /// In en, this message translates to:
  /// **'Enter text...'**
  String get enterText;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @paste.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get paste;

  /// No description provided for @aiOnline.
  ///
  /// In en, this message translates to:
  /// **'AI · Online'**
  String get aiOnline;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @translateFromImage.
  ///
  /// In en, this message translates to:
  /// **'Translate from Image'**
  String get translateFromImage;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @extractedText.
  ///
  /// In en, this message translates to:
  /// **'Extracted text'**
  String get extractedText;

  /// No description provided for @noTextFound.
  ///
  /// In en, this message translates to:
  /// **'No text found.'**
  String get noTextFound;

  /// No description provided for @useThisText.
  ///
  /// In en, this message translates to:
  /// **'Use this text'**
  String get useThisText;

  /// No description provided for @ocrError.
  ///
  /// In en, this message translates to:
  /// **'Could not read text from this image.'**
  String get ocrError;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'sw'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'sw':
      return AppLocalizationsSw();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
