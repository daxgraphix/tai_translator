import 'package:dio/dio.dart';

import '../constants/app_constants.dart';
import '../errors/exceptions.dart';

/// Thin client around Groq Cloud's OpenAI-compatible chat completion API.
/// This is the "Online Engine" referenced in the Translation Pipeline —
/// it only ever gets called by [TranslationCoordinator] when the device
/// has internet (see GroqTranslationSource).
class GroqTranslationService {
  final Dio _dio;
  final String apiKey;

  GroqTranslationService({required this.apiKey, Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: AppConstants.groqBaseUrl,
              connectTimeout: AppConstants.onlineTranslationBudget,
              receiveTimeout: AppConstants.onlineTranslationBudget,
            ));

  Future<String> translate({
    required String text,
    required String sourceLang,
    required String targetLang,
  }) async {
    if (apiKey.isEmpty) {
      throw ServerException('Groq API key not configured. Add one in Settings.');
    }

    final sourceName = AppConstants.languageNames[sourceLang] ?? sourceLang;
    final targetName = AppConstants.languageNames[targetLang] ?? targetLang;

    try {
      final response = await _dio.post(
        'chat/completions',
        options: Options(headers: {'Authorization': 'Bearer $apiKey'}),
        data: {
          'model': AppConstants.groqModel,
          'temperature': 0.1, // Lower temperature for more deterministic/correct results
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are a highly accurate $sourceName-to-$targetName translator. '
                  'Task: Translate the user text precisely. '
                  'Rules:\n'
                  '1. Output ONLY the translated text.\n'
                  '2. No explanations, no preamble, no conversational fillers.\n'
                  '3. Do NOT repeat the source text.\n'
                  '4. Maintain the tone and punctuation of the original.'
            },
            {'role': 'user', 'content': text},
          ],
        },
      );

      final content = response.data['choices']?[0]?['message']?['content'];
      if (content == null || content is! String || content.trim().isEmpty) {
        throw ServerException('Empty response from translation service.');
      }
      return content.trim();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Groq request failed.');
    }
  }
}
