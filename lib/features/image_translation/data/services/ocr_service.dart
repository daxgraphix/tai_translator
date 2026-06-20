import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// Wraps google_mlkit_text_recognition per spec's OCR Module flow:
/// Image -> ML Kit OCR -> Extract Text -> Translator -> Output.
class OcrService {
  final TextRecognizer _recognizer = TextRecognizer(script: TextRecognitionScript.latin);

  Future<String> extractText(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final RecognizedText recognizedText = await _recognizer.processImage(inputImage);
    return recognizedText.text;
  }

  Future<List<String>> extractLines(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final RecognizedText recognizedText = await _recognizer.processImage(inputImage);
    return recognizedText.blocks.expand((b) => b.lines).map((l) => l.text).toList();
  }

  void dispose() => _recognizer.close();
}
