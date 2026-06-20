import 'package:flutter_tts/flutter_tts.dart';

import '../../../../core/constants/app_constants.dart';

/// Wraps flutter_tts per spec's Text To Speech section: male/female
/// voice selection, speed and pitch control.
class TtsService {
  final FlutterTts _tts = FlutterTts();
  bool _configured = false;

  Future<void> _ensureConfigured() async {
    if (_configured) return;
    await _tts.awaitSpeakCompletion(true);
    _configured = true;
  }

  Future<void> speak(
    String text, {
    required String languageCode,
    double speed = 0.5,
    double pitch = 1.0,
  }) async {
    await _ensureConfigured();
    final locale = languageCode == AppConstants.langSwahili ? 'sw-TZ' : 'en-US';
    await _tts.setLanguage(locale);
    await _tts.setSpeechRate(speed);
    await _tts.setPitch(pitch);
    await _tts.speak(text);
  }

  Future<List<dynamic>> availableVoicesFor(String languageCode) async {
    final voices = await _tts.getVoices;
    if (voices is! List) return [];
    final locale = languageCode == AppConstants.langSwahili ? 'sw' : 'en';
    return voices.where((v) => (v['locale'] ?? '').toString().startsWith(locale)).toList();
  }

  Future<void> stop() => _tts.stop();
}
