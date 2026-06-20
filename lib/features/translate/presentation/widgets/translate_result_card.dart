import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../dictionary/presentation/providers/dictionary_providers.dart';
import '../../domain/entities/translation_result.dart';

class TranslateResultCard extends ConsumerWidget {
  final TranslationResult result;
  final VoidCallback onSpeak;
  final VoidCallback onFavorite;
  final VoidCallback onCopy;
  final VoidCallback onShare;
  final bool isFavorited;

  const TranslateResultCard({
    super.key,
    required this.result,
    required this.onSpeak,
    required this.onFavorite,
    required this.onCopy,
    required this.onShare,
    this.isFavorited = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 0,
      color: context.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: context.colors.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _EngineBadge(engine: result.engine),
                const Spacer(),
                Text(
                  result.targetLanguage.toUpperCase(),
                  style: context.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _TranslatedText(
              result: result,
            ),
            const SizedBox(height: 24),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ResultActionButton(
                  icon: Icons.volume_up_outlined,
                  onPressed: onSpeak,
                  tooltip: context.l10n.listen,
                ),
                _ResultActionButton(
                  icon: isFavorited ? Icons.favorite : Icons.favorite_border,
                  onPressed: onFavorite,
                  color: isFavorited ? context.colors.primary : null,
                  tooltip: context.l10n.favorites,
                ),
                _ResultActionButton(
                  icon: Icons.copy_outlined,
                  onPressed: onCopy,
                  tooltip: context.l10n.copiedToClipboard,
                ),
                _ResultActionButton(
                  icon: Icons.share_outlined,
                  onPressed: onShare,
                  tooltip: context.l10n.share,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TranslatedText extends ConsumerWidget {
  final TranslationResult result;

  const _TranslatedText({required this.result});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final words = result.translatedText.split(' ');

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: words.map((word) {
        final cleanWord = word.replaceAll(RegExp(r'[^\w\s]'), '');
        return InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () async {
            final entry = await ref.read(dictionaryLocalSourceProvider).search(cleanWord, limit: 1);
            if (entry.isNotEmpty && context.mounted) {
              context.push(AppRoutes.wordDetail, extra: entry.first.id);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              word,
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colors.onSurface,
                decoration: TextDecoration.underline,
                decorationStyle: TextDecorationStyle.dotted,
                decorationColor: context.colors.primary.withValues(alpha: 0.5),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ResultActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;
  final String? tooltip;

  const _ResultActionButton({
    required this.icon,
    required this.onPressed,
    this.color,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: onPressed,
      icon: Icon(icon, size: 22, color: color ?? context.colors.primary),
      tooltip: tooltip,
      style: IconButton.styleFrom(
        backgroundColor: context.colors.primary.withValues(alpha: 0.1),
      ),
    );
  }
}

class _EngineBadge extends StatelessWidget {
  final TranslationEngine engine;
  const _EngineBadge({required this.engine});

  @override
  Widget build(BuildContext context) {
    final online = engine == TranslationEngine.online;
    final label = online ? context.l10n.aiOnline : context.l10n.offline;
    final icon = online ? Icons.auto_awesome : Icons.bolt;
    final scheme = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: online 
            ? scheme.primary.withValues(alpha: 0.1) 
            : scheme.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: online ? scheme.primary : scheme.outline,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon, 
            size: 14, 
            color: online ? scheme.primary : scheme.onSurface.withValues(alpha: 0.6)
          ),
          const SizedBox(width: 6),
          Text(
            label, 
            style: context.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: online ? scheme.primary : scheme.onSurface.withValues(alpha: 0.6),
            )
          ),
        ],
      ),
    );
  }
}
