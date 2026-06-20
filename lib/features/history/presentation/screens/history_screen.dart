import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../translate/presentation/providers/translate_providers.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(translationHistoryStreamProvider);
    final dateFormat = DateFormat('MMM d, HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.history),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: context.l10n.clearHistory,
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(context.l10n.clearHistoryConfirmTitle),
                  content: Text(context.l10n.clearHistoryConfirmContent),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(context.l10n.cancel)),
                    FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(context.l10n.clear)),
                  ],
                ),
              );
              if (confirmed == true) {
                await ref.read(translationRepositoryProvider).clearHistory();
              }
            },
          ),
        ],
      ),
      body: historyAsync.when(
        loading: () => const LoadingIndicator(),
        error: (e, _) => Center(child: Text('$e')),
        data: (items) {
          if (items.isEmpty) {
            return EmptyState(
              icon: Icons.history,
              title: context.l10n.noHistoryTitle,
              subtitle: context.l10n.noHistorySubtitle,
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final item = items[i];
              return Dismissible(
                key: ValueKey(item.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: context.colors.errorContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.delete_outline),
                ),
                onDismissed: (_) =>
                    ref.read(translationRepositoryProvider).deleteHistoryItem(item.id),
                child: Card(
                  child: ListTile(
                    title: Text(item.sourceText, maxLines: 2, overflow: TextOverflow.ellipsis),
                    subtitle: Text(item.translatedText, maxLines: 2, overflow: TextOverflow.ellipsis),
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(dateFormat.format(item.createdAt),
                            style: Theme.of(context).textTheme.labelSmall),
                        Icon(
                          item.wasOnline ? Icons.cloud_outlined : Icons.offline_bolt_outlined,
                          size: 14,
                          color: context.colors.outline,
                        ),
                      ],
                    ),
                    onTap: () => Clipboard.setData(ClipboardData(text: item.translatedText)),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
