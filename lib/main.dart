import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/providers/core_providers.dart';
import 'core/storage/isar_service.dart';
import 'features/dictionary/data/datasources/dictionary_local_source.dart';
import 'features/learning/presentation/providers/learning_providers.dart';
import 'features/settings/presentation/providers/settings_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isar = await IsarService.open();
  final prefs = await SharedPreferences.getInstance();

  // First-launch seeding: dictionary, phrase database, flashcards.
  // Cheap no-ops on subsequent launches (counts are checked first).
  await DictionaryLocalSource(isar).seedIfEmpty();
  await LearningRepository(isar).seedFlashcardsIfEmpty();

  runApp(
    ProviderScope(
      overrides: [
        isarProvider.overrideWithValue(isar),
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const TaiTranslatorApp(),
    ),
  );
}