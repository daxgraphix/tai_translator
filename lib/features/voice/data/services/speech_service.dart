import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../../../core/constants/app_constants.dart';

/// Wraps speech_to_text per spec: "Speech To Text — Supported: English,
/// Swahili". Swahili STT availability depends on the device's installed
/// language packs; this service degrades gracefully when unavailable.
class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _initialized = false;

  Future<bool> initialize() async {
    if (_initialized) return true;
    _initialized = await _speech.initialize(
      onError: (e) => debugLog('SpeechService error: ${e.errorMsg}'),
      onStatus: (s) => debugLog('SpeechService status: $s'),
    );
    return _initialized;
  }

  bool get isListening => _speech.isListening;
  bool get isAvailable => _speech.isAvailable;

  /// [languageCode] should be 'en' or 'sw' (mapped to BCP-47 locales).
  Future<void> listen({
    required String languageCode,
    required void Function(String recognizedText, bool isFinal) onResult,
  }) async {
    final ready = await initialize();
    if (!ready) return;

    final locale = languageCode == AppConstants.langSwahili ? 'sw_TZ' : 'en_US';

    await _speech.listen(
      onResult: (result) => onResult(result.recognizedWords, result.finalResult),
      listenOptions: stt.SpeechListenOptions(
        localeId: locale,
        partialResults: true,
        cancelOnError: true,
      ),
    );
  }

  Future<void> stop() => _speech.stop();
  Future<void> cancel() => _speech.cancel();

  void debugLog(String message) {
    // Replace with a real logger if desired; kept silent in release builds.
    assert(() {
      // ignore: avoid_print
      print(message);
      return true;
    }());
  }
}
