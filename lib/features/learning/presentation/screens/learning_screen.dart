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
    final progressAsync = ref.watch(todayProgressProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.learn)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(context.l10n.dailyWord, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          dailyWordAsync.when(
            loading: () => const LoadingIndicator(),
            error: (e, _) => Text('$e'),
            data: (word) {
              if (word == null) return Text(context.l10n.noWordsAvailable);
              return Card(
                elevation: 0,
                color: context.colors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: context.colors.outline),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  title: Text(word.englishWord,
                      style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  subtitle: Text(word.swahiliWord, style: context.textTheme.titleMedium?.copyWith(color: context.colors.primary)),
                  trailing: IconButton.filledTonal(
                    style: IconButton.styleFrom(
                      backgroundColor: context.colors.primary.withValues(alpha: 0.1),
                    ),
                    icon: Icon(Icons.volume_up_outlined, color: context.colors.primary),
                    onPressed: () => ref.read(speakProvider)(word.swahiliWord, 'sw'),
                  ),
                ),
              );
            },
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
