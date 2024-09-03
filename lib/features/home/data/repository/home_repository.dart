import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:spotify/features/home/data/data_source/home_data_source.dart';

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
}
