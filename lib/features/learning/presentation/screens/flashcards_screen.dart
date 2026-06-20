import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../voice/presentation/providers/voice_providers.dart';
import '../providers/learning_providers.dart';

class FlashcardsScreen extends ConsumerStatefulWidget {
  const FlashcardsScreen({super.key});

  @override
  ConsumerState<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends ConsumerState<FlashcardsScreen> {
  int _index = 0;
  bool _showBack = false;

  @override
  Widget build(BuildContext context) {
    final deckAsync = ref.watch(flashcardDeckProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.flashcards)),
      body: deckAsync.when(
        loading: () => const LoadingIndicator(),
        error: (e, _) => Center(child: Text('$e')),
        data: (deck) {
          if (deck.isEmpty) {
            return EmptyState(
              icon: Icons.style_outlined,
              title: context.l10n.noFlashcardsTitle,
              subtitle: context.l10n.noFlashcardsSubtitle,
            );
          }
          if (_index >= deck.length) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.celebration_outlined, size: 80, color: context.colors.primary),
                    const SizedBox(height: 24),
                    Text(context.l10n.deckComplete, style: context.textTheme.headlineMedium),
                    const SizedBox(height: 32),
                    FilledButton.icon(
                      icon: const Icon(Icons.refresh),
                      onPressed: () => setState(() => _index = 0),
                      label: Text(context.l10n.restart),
                    ),
                  ],
                ),
              ),
            );
          }

          final card = deck[_index];
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: (_index) / deck.length,
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 12),
                Text('${_index + 1} / ${deck.length}', style: context.textTheme.labelLarge),
                const Spacer(),
                GestureDetector(
                  onTap: () => setState(() => _showBack = !_showBack),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return RotationTransition(
                        turns: animation,
                        child: child,
                      );
                    },
                    child: Card(
                      key: ValueKey(_showBack),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide(color: context.colors.outline),
                      ),
                      child: Container(
                        height: 300,
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _showBack ? card.back : card.front,
                              style: context.textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: _showBack ? context.colors.primary : context.colors.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              _showBack ? context.l10n.swahili : context.l10n.englishTapToFlip,
                              style: context.textTheme.labelLarge?.copyWith(
                                color: context.colors.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                IconButton.filledTonal(
                  onPressed: () => ref.read(speakProvider)(
                      _showBack ? card.back : card.front, _showBack ? 'sw' : 'en'),
                  icon: const Icon(Icons.volume_up_outlined),
                  tooltip: context.l10n.listen,
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.close),
                        label: Text(context.l10n.didntKnow),
                        onPressed: () => _next(card.id, false),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          foregroundColor: context.colors.error,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FilledButton.icon(
                        icon: const Icon(Icons.check),
                        label: Text(context.l10n.knewIt),
                        onPressed: () => _next(card.id, true),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _next(int cardId, bool knewIt) {
    ref.read(learningRepositoryProvider).recordReview(cardId, knewIt);
    setState(() {
      _index++;
      _showBack = false;
    });
  }
}
