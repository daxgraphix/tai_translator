import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../app/providers/core_providers.dart';
import '../../../../app/router.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../favorites/presentation/providers/favorites_providers.dart';
import '../../../voice/presentation/providers/voice_providers.dart';
import '../../domain/entities/translation_result.dart';
import '../providers/translate_providers.dart';
import '../widgets/language_bar.dart';
import '../widgets/translate_input_card.dart';
import '../widgets/translate_result_card.dart';

class TranslateScreen extends ConsumerStatefulWidget {
  const TranslateScreen({super.key});

  @override
  ConsumerState<TranslateScreen> createState() => _TranslateScreenState();
}

class _TranslateScreenState extends ConsumerState<TranslateScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onMicPressed() async {
    final speech = ref.read(speechServiceProvider);
    final state = ref.read(translateControllerProvider);
    final isListening = ref.read(isListeningProvider);

    if (isListening) {
      await speech.stop();
      ref.read(isListeningProvider.notifier).state = false;
      return;
    }

    final available = await speech.initialize();
    if (!available) {
      if (mounted) context.showSnack(context.l10n.voiceNotAvailable, isError: true);
      return;
    }

    ref.read(isListeningProvider.notifier).state = true;
    await speech.listen(
      languageCode: state.sourceLang,
      onResult: (text, isFinal) {
        _controller.text = text;
        ref.read(translateControllerProvider.notifier).setInputText(text);
        if (isFinal) ref.read(isListeningProvider.notifier).state = false;
      },
    );
  }

  Future<void> _onPaste() async {
    final data = await Clipboard.getData('text/plain');
    if (data?.text != null) {
      _controller.text = data!.text!;
      ref.read(translateControllerProvider.notifier).setInputText(data.text!);
    }
  }

  void _onCamera() async {
    final result = await context.push<String>(AppRoutes.imageTranslation);
    if (result != null && result.isNotEmpty) {
      _controller.text = result;
      ref.read(translateControllerProvider.notifier).setInputText(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(translateControllerProvider);
    final isListening = ref.watch(isListeningProvider);
    final isOnlineAsync = ref.watch(isOnlineProvider);

    ref.listen(translateControllerProvider.select((s) => s.failure), (prev, next) {
      if (next != null) context.showSnack(next.message, isError: true);
    });

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(context.l10n.appTitle),
            Text(
              context.l10n.appTagline,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
            ),
          ],
        ),
        actions: [
          isOnlineAsync.when(
            data: (online) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(
                online ? Icons.cloud_done_outlined : Icons.cloud_off_outlined,
                size: 20,
              ),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            LanguageBar(
              sourceLang: state.sourceLang,
              targetLang: state.targetLang,
              onSourceChanged: (l) => ref.read(translateControllerProvider.notifier).setSourceLang(l),
              onTargetChanged: (l) => ref.read(translateControllerProvider.notifier).setTargetLang(l),
              onSwap: () {
                ref.read(translateControllerProvider.notifier).swapLanguages();
                _controller.text = ref.read(translateControllerProvider).inputText;
              },
            ),
            const SizedBox(height: 16),
            TranslateInputCard(
              controller: _controller,
              onChanged: (text) => ref.read(translateControllerProvider.notifier).setInputText(text),
              onClear: () {
                _controller.clear();
                ref.read(translateControllerProvider.notifier).clear();
              },
              onMic: _onMicPressed,
              onCamera: _onCamera,
              onPaste: _onPaste,
            ),
            if (isListening)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.graphic_eq, color: context.colors.primary, size: 18),
                    const SizedBox(width: 6),
                    Text(context.l10n.listening, style: TextStyle(color: context.colors.primary)),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: state.isLoading
                  ? null
                  : () => ref.read(translateControllerProvider.notifier).translate(),
              icon: state.isLoading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.translate),
              label: Text(context.l10n.translate),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 16),
            _buildWordBookEntry(context),
            const SizedBox(height: 16),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.1),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: state.result != null 
                  ? _buildResult(context, state.result!)
                  : const SizedBox.shrink(key: ValueKey('empty')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResult(BuildContext context, TranslationResult result) {
    final favAsync = ref.watch(isFavoritedProvider(result.sourceText));
    return TranslateResultCard(
      key: ValueKey(result.sourceText + result.translatedText),
      result: result,
      isFavorited: favAsync.value ?? false,
      onSpeak: () => ref.read(speakProvider)(result.translatedText, result.targetLanguage),
      onFavorite: () => ref.read(favoritesRepositoryProvider).toggle(
            word: result.sourceText,
            translation: result.translatedText,
            sourceLanguage: result.sourceLanguage,
            targetLanguage: result.targetLanguage,
          ),
      onCopy: () {
        Clipboard.setData(ClipboardData(text: result.translatedText));
        context.showSnack(context.l10n.copiedToClipboard);
      },
      onShare: () => Share.share(result.translatedText),
    );
  }

  Widget _buildWordBookEntry(BuildContext context) {
    return Card(
      elevation: 0,
      color: context.colors.primaryContainer.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: context.colors.primary.withValues(alpha: 0.1)),
      ),
      child: InkWell(
        onTap: () => context.push(AppRoutes.dictionary),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.colors.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.menu_book, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.wordBook,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colors.onSurface,
                      ),
                    ),
                    Text(
                      context.l10n.wordBookSubtitle,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colors.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: context.colors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
