import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../favorites/presentation/providers/favorites_providers.dart';
import '../../../voice/presentation/providers/voice_providers.dart';
import '../providers/dictionary_providers.dart';

class WordDetailScreen extends ConsumerWidget {
  final int? entryId;
  const WordDetailScreen({super.key, required this.entryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (entryId == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(context.l10n.wordNotFound)),
      );
    }
    final entryAsync = ref.watch(dictionaryEntryProvider(entryId!));

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.word)),
      body: entryAsync.when(
        loading: () => const LoadingIndicator(),
        error: (e, _) => Center(child: Text('$e')),
        data: (entry) {
          if (entry == null) return Center(child: Text(context.l10n.wordNotFound));
          final favAsync = ref.watch(isFavoritedProvider(entry.englishWord));

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Card(
                margin: EdgeInsets.zero,
                elevation: 0,
                color: context.colors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(color: context.colors.outline),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              entry.englishWord,
                              style: context.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: context.colors.onSurface,
                              ),
                            ),
                          ),
                          IconButton.filledTonal(
                            style: IconButton.styleFrom(
                              backgroundColor: context.colors.primary.withValues(alpha: 0.1),
                            ),
                            icon: Icon(
                              (favAsync.value ?? false) ? Icons.favorite : Icons.favorite_border,
                              color: (favAsync.value ?? false) ? Colors.redAccent : context.colors.primary,
                            ),
                            onPressed: () => ref.read(favoritesRepositoryProvider).toggle(
                                  word: entry.englishWord,
                                  translation: entry.swahiliWord,
                                  sourceLanguage: 'en',
                                  targetLanguage: 'sw',
                                ),
                          ),
                          const SizedBox(width: 8),
                          IconButton.filledTonal(
                            style: IconButton.styleFrom(
                              backgroundColor: context.colors.primary.withValues(alpha: 0.1),
                            ),
                            icon: Icon(Icons.volume_up_outlined, color: context.colors.primary),
                            onPressed: () => ref.read(speakProvider)(entry.englishWord, 'en'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: context.colors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: context.colors.primary.withValues(alpha: 0.2)),
                        ),
                        child: Text(
                          entry.partOfSpeech.toUpperCase(),
                          style: context.textTheme.labelSmall?.copyWith(
                            color: context.colors.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Icon(Icons.arrow_downward, size: 24, color: Colors.grey),
              const SizedBox(height: 16),
              Card(
                margin: EdgeInsets.zero,
                elevation: 0,
                color: context.colors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(color: context.colors.outline),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.swahiliWord,
                          style: context.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.colors.onSurface,
                          ),
                        ),
                      ),
                      IconButton.filledTonal(
                        style: IconButton.styleFrom(
                          backgroundColor: context.colors.primary.withValues(alpha: 0.1),
                        ),
                        icon: Icon(Icons.volume_up_outlined, color: context.colors.primary),
                        onPressed: () => ref.read(speakProvider)(entry.swahiliWord, 'sw'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _Section(
                title: context.l10n.definition,
                icon: Icons.info_outline,
                content: entry.definition,
              ),
              if (entry.examples.isNotEmpty) ...[
                const SizedBox(height: 24),
                _Section(
                  title: context.l10n.examples,
                  icon: Icons.lightbulb_outline,
                  children: entry.examples
                      .map((e) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Icon(Icons.circle, size: 6, color: context.colors.primary),
                                ),
                                const SizedBox(width: 12),
                                Expanded(child: Text(e, style: context.textTheme.bodyLarge)),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? content;
  final List<Widget>? children;

  const _Section({
    required this.title,
    required this.icon,
    this.content,
    this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: context.colors.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (content != null)
          Text(content!, style: context.textTheme.bodyLarge?.copyWith(height: 1.5)),
        if (children != null) ...children!,
      ],
    );
  }
}
