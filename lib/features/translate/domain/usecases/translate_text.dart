import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/translation_result.dart';
import '../repositories/translation_repository.dart';

/// Single-responsibility use case so the presentation layer never talks
/// to the repository directly — easy to unit test in isolation.
class TranslateText {
  final TranslationRepository repository;
  TranslateText(this.repository);

  Future<Either<Failure, TranslationResult>> call({
    required String text,
    required String sourceLang,
    required String targetLang,
  }) {
    return repository.translate(text: text, sourceLang: sourceLang, targetLang: targetLang);
  }
}
