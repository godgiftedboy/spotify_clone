import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:spotify/features/home/data/data_source/home_data_source.dart';
import 'package:spotify/features/home/data/models/song_model.dart';

import '../../../../core/app_error.dart';
import '../../../../core/exception_handle.dart';

final homeRepositoryProvider = Provider(
  (ref) => HomeRepositoryImpl(
    homeDataSourceImpl: ref.watch(homeDataSourceProvider),
  ),
);

abstract class HomeRepository {
  Future<Either<AppError, String>> uploadSong(
    File selectedAudio,
    File selectedImage,
    String songName,
    String artist,
    String hexCode,
  );
  Future<Either<AppError, List<SongModel>>> getAllsSongs();
  Future<Either<AppError, bool>> favSong(SongModel song);
  Future<Either<AppError, List<SongModel>>> getAllFavSongs();
}

class HomeRepositoryImpl implements HomeRepository {
  final HomeDataSourceImpl homeDataSourceImpl;

  const HomeRepositoryImpl({required this.homeDataSourceImpl});
  @override
  Future<Either<AppError, String>> uploadSong(
    File selectedAudio,
    File selectedImage,
    String songName,
    String artist,
    String hexCode,
  ) async {
    try {
      final result = await homeDataSourceImpl.uploadSongDs(
        selectedAudio,
        selectedImage,
        songName,
        artist,
        hexCode,
      );
      return Right(result);
    } on DioExceptionHandle catch (e) {
      return Left(AppError(e.message!));
    }
  }

  @override
  Future<Either<AppError, List<SongModel>>> getAllsSongs() async {
    try {
      final result = await homeDataSourceImpl.getAllSongsDs();
      return Right(result);
    } on DioExceptionHandle catch (e) {
      return Left(AppError(e.message!));
    }
  }

  @override
  Future<Either<AppError, bool>> favSong(SongModel song) async {
    try {
      final result = await homeDataSourceImpl.favSongDs(song);
      return Right(result);
    } on DioExceptionHandle catch (e) {
      return Left(AppError(e.message!));
    }
  }

  @override
  Future<Either<AppError, List<SongModel>>> getAllFavSongs() async {
    try {
      final result = await homeDataSourceImpl.getAllFavSongsDs();
      return Right(result);
    } on DioExceptionHandle catch (e) {
      return Left(AppError(e.message!));
    }
  }
}
