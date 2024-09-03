import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/core/utils.dart';
import 'package:spotify/features/home/data/repository/home_repository.dart';

final homeControllerProvider =
    AsyncNotifierProvider<HomeController, String>(HomeController.new);

class HomeController extends AsyncNotifier<String> {
  late HomeRepository homeRepository;

  @override
  FutureOr<String> build() {
    homeRepository = ref.watch(homeRepositoryProvider);
    return "";
  }

  Future<void> uploadSong({
    required File selectedAudio,
    required File selectedImage,
    required String songName,
    required String artist,
    required Color selectedColor,
  }) async {
    state = const AsyncValue.loading();
    final result = await homeRepository.uploadSong(
      selectedAudio,
      selectedImage,
      songName,
      artist,
      rgbToHex(selectedColor),
    );
    result.fold(
      (l) => throw l.message,
      (r) => state = AsyncValue.data(r),
    );
  }
}
