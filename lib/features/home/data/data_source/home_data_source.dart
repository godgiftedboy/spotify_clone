import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/core/api_client.dart';
import 'package:spotify/core/api_const.dart';
import 'package:spotify/core/api_method_enum.dart';
import 'package:spotify/features/home/data/models/song_model.dart';

import '../../../../core/db_client.dart';

final homeDataSourceProvider = Provider(
  (ref) => HomeDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
    dbClient: ref.watch(dbClientProvider),
  ),
);

abstract class HomeDataSource {
  Future<void> uploadSongDs(
    File selectedAudio,
    File selectedImage,
    String songName,
    String artist,
    String hexCode,
  );

  Future<List<SongModel>> getAllSongsDs();
  Future<bool> favSongDs(SongModel song);
  Future<List<SongModel>> getAllFavSongsDs();
}

class HomeDataSourceImpl implements HomeDataSource {
  final ApiClient apiClient;
  final DbClient dbClient;
  HomeDataSourceImpl({required this.apiClient, required this.dbClient});
  @override
  Future<String> uploadSongDs(
    File selectedAudio,
    File selectedImage,
    String songName,
    String artist,
    String hexCode,
  ) async {
    final token = await dbClient.getData(
      dataType: LocalDataType.string,
      dbKey: "token",
    );

    FormData formData = FormData.fromMap({
      'artist': artist,
      'song_name': songName,
      'hex_code': hexCode,
      'song': await MultipartFile.fromFile(selectedAudio.path),
      'thumbnail': await MultipartFile.fromFile(selectedImage.path),
    });

    final result = await apiClient.request(
      path: ApiConst.uploadSong,
      type: ApiMethod.post,
      token: token,
      data: formData,
    );
    return result.toString();
  }

  @override
  Future<List<SongModel>> getAllSongsDs() async {
    final token = await dbClient.getData(
      dataType: LocalDataType.string,
      dbKey: "token",
    );
    final result = await apiClient.request(
      path: ApiConst.getAllSongs,
      token: token,
    );
    return List.from(result).map((song) => SongModel.fromMap(song)).toList();
  }

  @override
  Future<bool> favSongDs(SongModel song) async {
    final token = await dbClient.getData(
      dataType: LocalDataType.string,
      dbKey: "token",
    );
    final result = await apiClient.request(
        path: ApiConst.favSong,
        token: token,
        type: ApiMethod.post,
        data: {
          'song_id': song.id,
        });
    return result['message'];
  }

  @override
  Future<List<SongModel>> getAllFavSongsDs() async {
    final token = await dbClient.getData(
      dataType: LocalDataType.string,
      dbKey: "token",
    );
    final result = await apiClient.request(
      path: ApiConst.favSongList,
      token: token,
    );
    return List.from(result)
        .map((element) => SongModel.fromMap(element['song']))
        .toList();
  }
}
