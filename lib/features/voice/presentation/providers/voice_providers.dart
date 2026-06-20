import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../settings/presentation/providers/settings_providers.dart';
import '../../data/services/speech_service.dart';
import '../../data/services/tts_service.dart';

final speechServiceProvider = Provider<SpeechService>((ref) => SpeechService());
final ttsServiceProvider = Provider<TtsService>((ref) => TtsService());

final isListeningProvider = StateProvider<bool>((ref) => false);

/// Convenience wrapper so screens can call one method instead of wiring
/// speed/pitch from Settings every time.
final speakProvider = Provider<Future<void> Function(String text, String languageCode)>((ref) {
  return (text, languageCode) {
    final tts = ref.read(ttsServiceProvider);
    return tts.speak(
      text,
      languageCode: languageCode,
      speed: ref.read(voiceSpeedProvider),
      pitch: ref.read(voicePitchProvider),
    );
  };
});
