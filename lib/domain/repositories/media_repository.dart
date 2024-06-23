import 'dart:convert';

import 'package:flutter_football/data/data_sources/media_data_source.dart';
import 'package:flutter_football/data/data_sources/shared_preferences_data_source.dart';
import 'package:flutter_football/presentation/blocs/media/media_state.dart';

class MediaRepository {
  final MediaDataSource mediaDataSource;
  SharedPreferencesDataSource preferencesDataSource;

  MediaRepository({
    required this.mediaDataSource,
    required this.preferencesDataSource,
  });


  Future<String> getAvatar(String name) async {
    try {
      return await mediaDataSource.getAvatar(name);
    } catch(error) {
      print(error);
      rethrow;
    }
  }

  Future<String> getDefaultAvatar() async {
    try {
      return await mediaDataSource.getDefaultAvatar();
    } catch(error) {
      print(error);
      rethrow;
    }
  }

  Future<String> getClubRule() async {
    try {
      return await mediaDataSource.getClubRule();
    } catch(error) {
      print(error);
      rethrow;
    }
  }

  Future<List<Video>> getVideosBucket(String bucketName) async {
    try {
      return await mediaDataSource.getVideosBucket(bucketName);
    } catch(error) {
      print(error);
      rethrow;
    }
  }

  Future<List<Video>> getSpecificVideos() async {
    final idPlayer = preferencesDataSource.getIdPlayer();

    try {
      final videos = await mediaDataSource.getSpecificVideos(idPlayer);
      final data = jsonDecode(videos)["videos"] as List<dynamic>;
      return List<Video>.from(data.map((model) => Video.fromJson(model)));
    } catch (error) {
      print(error);
      rethrow;
    }
  }

}