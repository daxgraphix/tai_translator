import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../voice/presentation/providers/voice_providers.dart';
import '../providers/learning_providers.dart';

/// Learning hub: Daily Word, Daily Phrase, Flashcards, Quiz Mode —
/// purpose, per spec, is to "increase daily engagement."
class LearningScreen extends ConsumerWidget {
  const LearningScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyWordAsync = ref.watch(dailyWordProvider);
    final dailyPhraseAsync = ref.watch(dailyPhraseProvider);
    final progressAsync = ref.watch(todayProgressProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.learn)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.l10n.dailyWord, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Expanded(
                        child: dailyWordAsync.when(
                          loading: () => const Center(child: LoadingIndicator()),
                          error: (e, _) => Text('$e'),
                          data: (word) {
                            if (word == null) return Text(context.l10n.noWordsAvailable);
                            return _DailyItemCard(
                              title: word.englishWord,
                              subtitle: word.swahiliWord,
                              onSpeak: () => ref.read(speakProvider)(word.swahiliWord, 'sw'),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.l10n.dailyPhrase, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Expanded(
                        child: dailyPhraseAsync.when(
                          loading: () => const Center(child: LoadingIndicator()),
                          error: (e, _) => Text('$e'),
                          data: (phrase) {
                            if (phrase == null) return Text(context.l10n.noPhrasesAvailable);
                            return _DailyItemCard(
                              title: phrase.englishPhrase,
                              subtitle: phrase.swahiliPhrase,
                              onSpeak: () => ref.read(speakProvider)(phrase.swahiliPhrase, 'sw'),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(context.l10n.todaysProgress, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          progressAsync.when(
            loading: () => const LoadingIndicator(),
            error: (e, _) => Text('$e'),
            data: (progress) => Card(
              elevation: 0,
              color: context.colors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: context.colors.outline),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatColumn(label: context.l10n.wordsLearned, value: '${progress?.wordsLearned ?? 0}'),
                    _StatColumn(label: context.l10n.quizzesCompleted, value: '${progress?.quizzesCompleted ?? 0}'),
                    _StatColumn(
                      label: context.l10n.accuracy,
                      value: progress == null || progress.quizTotalAnswers == 0
                          ? '—'
                          : '${((progress.quizCorrectAnswers / progress.quizTotalAnswers) * 100).round()}%',
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(context.l10n.practice, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          _PracticeCard(
            icon: Icons.style_outlined,
            title: context.l10n.flashcards,
            subtitle: context.l10n.flashcardsSubtitle,
            onTap: () => context.push(AppRoutes.flashcards),
          ),
          const SizedBox(height: 8),
          _PracticeCard(
            icon: Icons.quiz_outlined,
            title: context.l10n.quizMode,
            subtitle: context.l10n.quizModeSubtitle,
            onTap: () => context.push(AppRoutes.quiz),
          ),
        ],
      ),
    );
  }
}

class _DailyItemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onSpeak;

  const _DailyItemCard({
    required this.title,
    required this.subtitle,
    required this.onSpeak,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: context.colors.surface,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: context.colors.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: context.textTheme.bodyMedium?.copyWith(color: context.colors.primary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton.filledTonal(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.volume_up_outlined, size: 20),
                onPressed: onSpeak,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PracticeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _PracticeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: context.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: context.colors.outline),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: context.colors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: context.colors.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  const _StatColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: context.colors.primary,
          fontWeight: FontWeight.bold,
        )),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
