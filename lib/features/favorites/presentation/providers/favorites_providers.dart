import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../../app/providers/core_providers.dart';
import '../../data/models/favorite_model.dart';

class FavoritesRepository {
  final Isar isar;
  FavoritesRepository(this.isar);

  Stream<List<FavoriteModel>> watchAll() {
    return isar.favoriteModels.where().sortByCreatedAtDesc().watch(fireImmediately: true);
  }

  Future<bool> isFavorited(String word) async {
    final existing = await isar.favoriteModels.filter().wordEqualTo(word).findFirst();
    return existing != null;
  }

  Future<void> toggle({
    required String word,
    required String translation,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    final existing = await isar.favoriteModels.filter().wordEqualTo(word).findFirst();
    await isar.writeTxn(() async {
      if (existing != null) {
        await isar.favoriteModels.delete(existing.id);
      } else {
        await isar.favoriteModels.put(
          FavoriteModel()
            ..word = word
            ..translation = translation
            ..sourceLanguage = sourceLanguage
            ..targetLanguage = targetLanguage
            ..createdAt = DateTime.now(),
        );
      }
    });
  }

  Future<void> remove(int id) async {
    await isar.writeTxn(() async => isar.favoriteModels.delete(id));
  }
}

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepository(ref.watch(isarProvider));
});

final favoritesStreamProvider = StreamProvider<List<FavoriteModel>>((ref) {
  return ref.watch(favoritesRepositoryProvider).watchAll();
});

final isFavoritedProvider = FutureProvider.family<bool, String>((ref, word) {
  // Re-evaluate whenever the favorites list changes.
  ref.watch(favoritesStreamProvider);
  return ref.watch(favoritesRepositoryProvider).isFavorited(word);
});
