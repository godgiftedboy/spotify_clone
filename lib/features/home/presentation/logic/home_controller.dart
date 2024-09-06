import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/core/utils.dart';
import 'package:spotify/features/home/data/models/song_model.dart';
import 'package:spotify/features/home/data/repository/home_local_repository.dart';
import 'package:spotify/features/home/data/repository/home_repository.dart';

final homeControllerProvider =
    AsyncNotifierProvider<HomeController, List<SongModel>>(HomeController.new);

class HomeController extends AsyncNotifier<List<SongModel>> {
  late HomeRepository homeRepository;
  late HomeLocalRepository _homeLocalRepository;

  @override
  FutureOr<List<SongModel>> build() {
    homeRepository = ref.watch(homeRepositoryProvider);
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return getAllSongs();
  }

  FutureOr<List<SongModel>> getAllSongs() async {
    final result = await homeRepository.getAllsSongs();
    return result.fold(
      (l) => throw l.message,
      (r) => r,
    );
  }

  Future<void> uploadSong({
    required File selectedAudio,
    required File selectedImage,
    required String songName,
    required String artist,
    required Color selectedColor,
  }) async {
    final result = await homeRepository.uploadSong(
      selectedAudio,
      selectedImage,
      songName,
      artist,
      rgbToHex(selectedColor),
    );
    result.fold(
      (l) => throw l.message,
      (r) => r,
    );
  }

  List<SongModel> getRecentlyPlayedSongs() {
    return _homeLocalRepository.loadSongs();
  }
}
