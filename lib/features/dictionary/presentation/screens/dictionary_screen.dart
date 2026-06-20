import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../providers/dictionary_providers.dart';

class DictionaryScreen extends ConsumerWidget {
  const DictionaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(dictionarySearchQueryProvider);
    final resultsAsync = ref.watch(dictionarySearchResultsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.dictionary), centerTitle: true),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                style: TextStyle(color: context.colors.onSurface),
                decoration: InputDecoration(
                  hintText: context.l10n.searchHint,
                  prefixIcon: Icon(Icons.search, color: context.colors.primary),
                  suffixIcon: query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () =>
                              ref.read(dictionarySearchQueryProvider.notifier).state = '',
                        )
                      : null,
                ),
                onChanged: (v) => ref.read(dictionarySearchQueryProvider.notifier).state = v,
              ),
            ),
            Expanded(
              child: query.trim().isEmpty
                  ? EmptyState(
                      icon: Icons.menu_book_outlined,
                      title: context.l10n.dictionaryEmptyStateTitle,
                      subtitle: context.l10n.dictionaryEmptyStateSubtitle,
                    )
                  : resultsAsync.when(
                      loading: () => const LoadingIndicator(),
                      error: (e, _) => EmptyState(icon: Icons.error_outline, title: '$e'),
                      data: (results) {
                        if (results.isEmpty) {
                          return EmptyState(
                            icon: Icons.search_off,
                            title: context.l10n.noMatchesFound,
                            subtitle: context.l10n.noMatchesSubtitle,
                          );
                        }
                        return ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: results.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, i) {
                            final entry = results[i];
                            return Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(color: context.colors.outlineVariant.withValues(alpha: 0.5)),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                title: Text(
                                  entry.englishWord,
                                  style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(
                                      entry.swahiliWord,
                                      style: context.textTheme.bodyLarge?.copyWith(color: context.colors.primary),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: context.colors.secondaryContainer,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        entry.partOfSpeech,
                                        style: context.textTheme.labelSmall?.copyWith(
                                          color: context.colors.onSecondaryContainer,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Icon(Icons.chevron_right, color: context.colors.outline),
                                onTap: () => context.push(AppRoutes.wordDetail, extra: entry.id),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
