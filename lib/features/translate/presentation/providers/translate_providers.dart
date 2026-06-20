import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/core_providers.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/groq_translation_service.dart';
import '../../../dictionary/presentation/providers/dictionary_providers.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../../data/datasources/groq_translation_source.dart';
import '../../data/datasources/offline_translation_source.dart';
import '../../data/repositories/translation_repository_impl.dart';
import '../../domain/entities/translation_result.dart';
import '../../domain/repositories/translation_repository.dart';
import '../../domain/usecases/translate_text.dart';

final offlineTranslationSourceProvider = Provider<OfflineTranslationSource>((ref) {
  return OfflineTranslationSource(ref.watch(dictionaryLocalSourceProvider));
});

final groqServiceProvider = Provider<GroqTranslationService>((ref) {
  final apiKey = ref.watch(groqApiKeyProvider).value ?? '';
  return GroqTranslationService(apiKey: apiKey);
});

final groqTranslationSourceProvider = Provider<GroqTranslationSource>((ref) {
  return GroqTranslationSource(ref.watch(groqServiceProvider));
});

final translationRepositoryProvider = Provider<TranslationRepository>((ref) {
  return TranslationRepositoryImpl(
    offlineSource: ref.watch(offlineTranslationSourceProvider),
    onlineSource: ref.watch(groqTranslationSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
    isar: ref.watch(isarProvider),
    onlineEnabled: ref.watch(onlineTranslationEnabledProvider),
  );
});

final translateTextUseCaseProvider = Provider<TranslateText>((ref) {
  return TranslateText(ref.watch(translationRepositoryProvider));
});

final translationHistoryStreamProvider = StreamProvider<List<TranslationHistoryEntry>>((ref) {
  return ref.watch(translationRepositoryProvider).watchHistory();
});

// ---------------- Translate screen state ----------------

class TranslateState {
  final String sourceLang;
  final String targetLang;
  final String inputText;
  final TranslationResult? result;
  final bool isLoading;
  final Failure? failure;

  const TranslateState({
    this.sourceLang = AppConstants.langEnglish,
    this.targetLang = AppConstants.langSwahili,
    this.inputText = '',
    this.result,
    this.isLoading = false,
    this.failure,
  });

  TranslateState copyWith({
    String? sourceLang,
    String? targetLang,
    String? inputText,
    TranslationResult? result,
    bool? isLoading,
    Failure? failure,
    bool clearResult = false,
    bool clearFailure = false,
  }) {
    return TranslateState(
      sourceLang: sourceLang ?? this.sourceLang,
      targetLang: targetLang ?? this.targetLang,
      inputText: inputText ?? this.inputText,
      result: clearResult ? null : (result ?? this.result),
      isLoading: isLoading ?? this.isLoading,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }
}

class TranslateController extends Notifier<TranslateState> {
  Timer? _debounceTimer;

  @override
  TranslateState build() {
    ref.onDispose(() => _debounceTimer?.cancel());
    return const TranslateState();
  }

  void setInputText(String text) {
    state = state.copyWith(inputText: text, clearResult: text.isEmpty);

    // Debounce offline translation
    _debounceTimer?.cancel();
    if (text.isNotEmpty) {
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        translate(isAuto: true);
      });
    }
  }

  void swapLanguages() {
    state = state.copyWith(
      sourceLang: state.targetLang,
      targetLang: state.sourceLang,
      inputText: state.result?.translatedText ?? '',
      clearResult: true,
    );
    if (state.inputText.isNotEmpty) {
      translate();
    }
  }

  void setSourceLang(String lang) {
    if (lang == state.targetLang) {
      swapLanguages();
      return;
    }
    state = state.copyWith(sourceLang: lang, clearResult: true);
    if (state.inputText.isNotEmpty) {
      translate();
    }
  }

  void setTargetLang(String lang) {
    if (lang == state.sourceLang) {
      swapLanguages();
      return;
    }
    state = state.copyWith(targetLang: lang, clearResult: true);
    if (state.inputText.isNotEmpty) {
      translate();
    }
  }

  Future<void> translate({bool isAuto = false}) async {
    final text = state.inputText.trim();
    if (text.isEmpty) return;

    // Show loading state for both manual and auto-translations
    state = state.copyWith(isLoading: true, clearFailure: true);

    final useCase = ref.read(translateTextUseCaseProvider);
    final either = await useCase(
      text: text,
      sourceLang: state.sourceLang,
      targetLang: state.targetLang,
    );

    // Prevent race conditions: if the input changed while we were waiting, ignore this result
    if (state.inputText.trim() != text) return;

    either.fold(
      (failure) {
        // Reset loading state and show error only if it's not an auto-translation
        state = state.copyWith(
          isLoading: false,
          failure: isAuto ? null : failure,
        );
      },
      (result) {
        state = state.copyWith(isLoading: false, result: result, clearFailure: true);
        // Always save to history to ensure the local cache is updated
        ref.read(translationRepositoryProvider).saveToHistory(result);
      },
    );
  }

  void clear() {
    state = state.copyWith(inputText: '', clearResult: true, clearFailure: true);
  }
}

final translateControllerProvider =
    NotifierProvider<TranslateController, TranslateState>(TranslateController.new);
