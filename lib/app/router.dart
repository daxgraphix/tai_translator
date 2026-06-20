import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/translate/presentation/screens/translate_screen.dart';
import '../features/dictionary/presentation/screens/dictionary_screen.dart';
import '../features/dictionary/presentation/screens/word_detail_screen.dart';
import '../features/learning/presentation/screens/learning_screen.dart';
import '../features/learning/presentation/screens/flashcards_screen.dart';
import '../features/learning/presentation/screens/quiz_screen.dart';
import '../features/history/presentation/screens/history_screen.dart';
import '../features/favorites/presentation/screens/favorites_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';
import '../features/image_translation/presentation/screens/image_translation_screen.dart';
import 'app_shell.dart';

/// Route paths, centralized so screens never hardcode strings.
class AppRoutes {
  AppRoutes._();
  static const translate = '/translate';
  static const dictionary = '/dictionary';
  static const wordDetail = '/dictionary/word';
  static const learn = '/learn';
  static const flashcards = '/learn/flashcards';
  static const quiz = '/learn/quiz';
  static const history = '/history';
  static const favorites = '/favorites';
  static const settings = '/settings';
  static const imageTranslation = '/translate/image';
}

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// Bottom navigation: Translate, Dictionary, Learn, History, Settings.
/// Max 5 tabs per spec; everything else (favorites, image translation,
/// word detail, flashcards, quiz) uses nested/pushed navigation.
final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.translate,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.translate,
            builder: (context, state) => const TranslateScreen(),
            routes: [
              GoRoute(
                path: 'image',
                parentNavigatorKey: rootNavigatorKey,
                builder: (context, state) => const ImageTranslationScreen(),
              ),
            ],
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.dictionary,
            builder: (context, state) => const DictionaryScreen(),
            routes: [
              GoRoute(
                path: 'word',
                parentNavigatorKey: rootNavigatorKey,
                builder: (context, state) {
                  final entryId = state.extra as int?;
                  return WordDetailScreen(entryId: entryId);
                },
              ),
            ],
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.learn,
            builder: (context, state) => const LearningScreen(),
            routes: [
              GoRoute(
                path: 'flashcards',
                parentNavigatorKey: rootNavigatorKey,
                builder: (context, state) => const FlashcardsScreen(),
              ),
              GoRoute(
                path: 'quiz',
                parentNavigatorKey: rootNavigatorKey,
                builder: (context, state) => const QuizScreen(),
              ),
            ],
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.history,
            builder: (context, state) => const HistoryScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.settings,
            builder: (context, state) => const SettingsScreen(),
          ),
        ]),
      ],
    ),
    GoRoute(
      path: AppRoutes.favorites,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const FavoritesScreen(),
    ),
  ],
);
