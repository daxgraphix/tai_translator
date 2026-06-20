import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../voice/presentation/providers/voice_providers.dart';
import '../providers/favorites_providers.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesStreamProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.favorites)),
      body: favoritesAsync.when(
        loading: () => const LoadingIndicator(),
        error: (e, _) => Center(child: Text('$e')),
        data: (items) {
          if (items.isEmpty) {
            return EmptyState(
              icon: Icons.favorite_border,
              title: context.l10n.noFavoritesTitle,
              subtitle: context.l10n.noFavoritesSubtitle,
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            itemBuilder: (context, i) {
              final item = items[i];
              return Card(
                child: ListTile(
                  title: Text(item.word),
                  subtitle: Text(item.translation),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.volume_up_outlined),
                        onPressed: () => ref.read(speakProvider)(item.translation, item.targetLanguage),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => ref.read(favoritesRepositoryProvider).remove(item.id),
                      ),
                    ],
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
