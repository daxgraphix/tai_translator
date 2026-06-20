import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../app/providers/core_providers.dart';
import '../../../../core/constants/app_constants.dart';

/// Overridden in main.dart with the resolved SharedPreferences instance.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden in main()');
});

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final raw = ref.read(sharedPreferencesProvider).getString(AppConstants.prefThemeMode);
    return switch (raw) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  void set(ThemeMode mode) {
    state = mode;
    ref.read(sharedPreferencesProvider).setString(AppConstants.prefThemeMode, mode.name);
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

class OnlineTranslationToggleNotifier extends Notifier<bool> {
  @override
  bool build() =>
      ref.read(sharedPreferencesProvider).getBool(AppConstants.prefOnlineTranslationEnabled) ??
      true;

  void set(bool value) {
    state = value;
    ref
        .read(sharedPreferencesProvider)
        .setBool(AppConstants.prefOnlineTranslationEnabled, value);
  }
}

final onlineTranslationEnabledProvider =
    NotifierProvider<OnlineTranslationToggleNotifier, bool>(OnlineTranslationToggleNotifier.new);

class GroqApiKeyNotifier extends AsyncNotifier<String> {
  @override
  Future<String> build() async {
    final storage = ref.read(secureStorageProvider);
    final savedKey = await storage.read(key: AppConstants.prefGroqApiKey);
    if (savedKey != null && savedKey.isNotEmpty) {
      return savedKey;
    }
    // Fallback to the pre-configured API key
    return AppConstants.defaultGroqApiKey;
  }

  Future<void> set(String value) async {
    state = const AsyncValue.loading();
    final storage = ref.read(secureStorageProvider);
    await storage.write(key: AppConstants.prefGroqApiKey, value: value);
    state = AsyncValue.data(value);
  }
}

final groqApiKeyProvider = AsyncNotifierProvider<GroqApiKeyNotifier, String>(GroqApiKeyNotifier.new);

class VoiceSpeedNotifier extends Notifier<double> {
  @override
  double build() => ref.read(sharedPreferencesProvider).getDouble(AppConstants.prefVoiceSpeed) ?? 0.5;

  void set(double value) {
    state = value;
    ref.read(sharedPreferencesProvider).setDouble(AppConstants.prefVoiceSpeed, value);
  }
}

final voiceSpeedProvider = NotifierProvider<VoiceSpeedNotifier, double>(VoiceSpeedNotifier.new);

class VoicePitchNotifier extends Notifier<double> {
  @override
  double build() => ref.read(sharedPreferencesProvider).getDouble(AppConstants.prefVoicePitch) ?? 1.0;

  void set(double value) {
    state = value;
    ref.read(sharedPreferencesProvider).setDouble(AppConstants.prefVoicePitch, value);
  }
}

final voicePitchProvider = NotifierProvider<VoicePitchNotifier, double>(VoicePitchNotifier.new);
