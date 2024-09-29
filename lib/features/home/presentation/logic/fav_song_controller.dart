import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/core/providers/current_user_provider.dart';
import 'package:spotify/features/home/data/models/song_model.dart';
import 'package:spotify/features/home/data/repository/home_repository.dart';

import '../../data/models/fav_song_model.dart';

final favSongControllerProvider =
    AutoDisposeAsyncNotifierProvider<FavSongController, List<SongModel>>(
        FavSongController.new);

class FavSongController extends AutoDisposeAsyncNotifier<List<SongModel>> {
  late HomeRepository homeRepository;

  @override
  FutureOr<List<SongModel>> build() {
    homeRepository = ref.watch(homeRepositoryProvider);
    return getAllFavSongs();
  }

  Future<void> favSong(SongModel song) async {
    final result = await homeRepository.favSong(song);
    result.fold(
      (l) => throw l.message,
      (r) => _favSongSuccess(r, song.id),
    );
  }

  _favSongSuccess(bool isFavorited, String songId) {
    final userNotifier = ref.watch(currentUserProvider.notifier);
    final currentUser = ref.read(currentUserProvider);
    if (isFavorited) {
      userNotifier.addUser(
        currentUser!.copyWith(favorites: [
          ...ref.read(currentUserProvider)!.favorites,
          FavSongModel(id: "id", song_id: songId, user_id: "user_id"),
        ]),
      );
    } else {
      userNotifier.addUser(currentUser!.copyWith(
          favorites: currentUser.favorites
              .where(
                (fav) => fav.song_id != songId,
              )
              .toList()));
    }
  }

  FutureOr<List<SongModel>> getAllFavSongs() async {
    final result = await homeRepository.getAllFavSongs();
    return result.fold(
      (l) => throw l.message,
      (r) => r,
    );
  }
}
