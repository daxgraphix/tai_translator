import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../providers/learning_providers.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  int _index = 0;
  int _correct = 0;
  String? _selected;
  bool _resultRecorded = false;

  @override
  Widget build(BuildContext context) {
    final questionsAsync = ref.watch(quizQuestionsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.quizMode)),
      body: questionsAsync.when(
        loading: () => const LoadingIndicator(),
        error: (e, _) => Center(child: Text('$e')),
        data: (questions) {
          if (questions.isEmpty) {
            return EmptyState(
              icon: Icons.quiz_outlined,
              title: context.l10n.notEnoughWordsTitle,
              subtitle: context.l10n.notEnoughWordsSubtitle,
            );
          }
          if (_index >= questions.length) {
            if (!_resultRecorded) {
              _resultRecorded = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ref
                    .read(learningRepositoryProvider)
                    .recordQuizResult(correct: _correct, total: questions.length);
              });
            }
            return _ResultView(
              correct: _correct,
              total: questions.length,
              onRetry: () => setState(() {
                _index = 0;
                _correct = 0;
                _selected = null;
                _resultRecorded = false;
              }),
            );
          }

          final q = questions[_index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: (_index + 1) / questions.length,
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  context.l10n.questionCount(_index + 1, questions.length),
                  style: context.textTheme.labelLarge?.copyWith(color: context.colors.outline),
                ),
                const SizedBox(height: 12),
                Text(
                  context.l10n.quizQuestion(q.question),
                  style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                ...q.options.map((option) {
                  final isSelected = _selected == option;
                  final isCorrect = option == q.correctAnswer;
                  
                  Color cardColor = context.colors.surface;
                  Color borderColor = context.colors.outlineVariant;
                  Widget? trailing;

                  if (_selected != null) {
                    if (isCorrect) {
                      cardColor = context.colors.primaryContainer;
                      borderColor = context.colors.primary;
                      trailing = Icon(Icons.check_circle, color: context.colors.primary);
                    } else if (isSelected) {
                      cardColor = context.colors.errorContainer;
                      borderColor = context.colors.error;
                      trailing = Icon(Icons.cancel, color: context.colors.error);
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor, width: 2),
                      ),
                      child: ListTile(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        title: Text(
                          option,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        trailing: trailing,
                        onTap: _selected == null ? () => _select(option, q.correctAnswer) : null,
                      ),
                    ),
                  );
                }),
                const Spacer(),
                if (_selected != null)
                  FilledButton(
                    onPressed: () => setState(() {
                      _index++;
                      _selected = null;
                    }),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(context.l10n.next),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _select(String option, String correctAnswer) {
    setState(() {
      _selected = option;
      if (option == correctAnswer) _correct++;
    });
  }
}

class _ResultView extends StatelessWidget {
  final int correct;
  final int total;
  final VoidCallback onRetry;

  const _ResultView({
    required this.correct,
    required this.total,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final pct = total == 0 ? 0 : ((correct / total) * 100).round();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: context.colors.primaryContainer,
                shape: BoxShape.circle,
                border: Border.all(color: context.colors.primary.withValues(alpha: 0.2)),
              ),
              child: Icon(Icons.emoji_events_outlined, size: 80, color: context.colors.primary),
            ),
            const SizedBox(height: 32),
            Text(
              context.l10n.scoreResult(correct, total),
              style: context.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              '$pct%',
              style: context.textTheme.displayMedium?.copyWith(
                color: context.colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 48),
            FilledButton.icon(
              icon: const Icon(Icons.refresh),
              onPressed: onRetry,
              label: Text(context.l10n.tryAgain),
              style: FilledButton.styleFrom(
                minimumSize: const Size(200, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
