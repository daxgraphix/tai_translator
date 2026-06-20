import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../data/services/ocr_service.dart';

final _ocrServiceProvider = Provider<OcrService>((ref) => OcrService());

/// OCR Module screen: pick or capture an image, run ML Kit text
/// recognition, then hand the extracted text back to TranslateScreen.
class ImageTranslationScreen extends ConsumerStatefulWidget {
  const ImageTranslationScreen({super.key});

  @override
  ConsumerState<ImageTranslationScreen> createState() => _ImageTranslationScreenState();
}

class _ImageTranslationScreenState extends ConsumerState<ImageTranslationScreen> {
  File? _image;
  String? _extractedText;
  bool _isProcessing = false;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 90);
    if (picked == null) return;

    setState(() {
      _image = File(picked.path);
      _isProcessing = true;
      _extractedText = null;
    });

    try {
      final text = await ref.read(_ocrServiceProvider).extractText(_image!);
      setState(() => _extractedText = text);
    } catch (e) {
      if (mounted) context.showSnack(context.l10n.ocrError, isError: true);
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.translateFromImage)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (_image != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(_image!, height: 200, fit: BoxFit.cover, width: double.infinity),
                )
              else
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: context.colors.outline),
                  ),
                  child: Icon(Icons.image_outlined, size: 48, color: context.colors.outline),
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.photo_camera_outlined),
                      label: Text(l10n.camera),
                      onPressed: () => _pickImage(ImageSource.camera),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.photo_library_outlined),
                      label: Text(l10n.gallery),
                      onPressed: () => _pickImage(ImageSource.gallery),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (_isProcessing) const CircularProgressIndicator(),
              if (_extractedText != null) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(l10n.extractedText, style: Theme.of(context).textTheme.titleSmall),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SingleChildScrollView(
                        child: Text(_extractedText!.isEmpty ? l10n.noTextFound : _extractedText!),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  icon: const Icon(Icons.translate),
                  label: Text(l10n.useThisText),
                  onPressed: _extractedText!.trim().isEmpty
                      ? null
                      : () => Navigator.of(context).pop(_extractedText),
                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
