import 'dart:convert';
import 'dart:io';

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

  Future<String?> getAvatar() async {
    try {
      final String? idUser = preferencesDataSource.getIdCoach()?.toString() ??
          preferencesDataSource.getIdPlayer();
      if (idUser != null) {
        return await mediaDataSource.getAvatar("$idUser.jpg");
      }
      return null;
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<String> getUserAvatar(String idUser) async {
    try {
      return await mediaDataSource.getAvatar("$idUser.jpg");
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<String> getDefaultAvatar() async {
    try {
      return await mediaDataSource.getDefaultAvatar();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<String> getClubRule() async {
    try {
      return await mediaDataSource.getClubRule();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<String> getCoachRule() async {
    try {
      return await mediaDataSource.getCoachRule();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<String> getDocumentClub() async {
    try {
      return await mediaDataSource.getDocumentClub();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<List<Video>> getVideosBucket(String bucketName) async {
    try {
      return await mediaDataSource.getVideosBucket(bucketName);
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<List<String>> getMatchBucketImages(String matchId) async {
    try {
      return await mediaDataSource.getMatchBucketImages(matchId);
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<String> updateProfilePicture(File imageFile) async {
    try {
      final String? userID = preferencesDataSource.getIdCoach()?.toString() ??
          preferencesDataSource.getIdPlayer();
      return await mediaDataSource.updateProfilePicture(
          imageFile, "$userID.jpg");
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<List<Video>> getSpecificVideos() async {
    final idPlayer = preferencesDataSource.getIdPlayer();

    try {
      final videos = await mediaDataSource.getSpecificVideos(idPlayer!);
      final data = jsonDecode(videos)["videos"] as List<dynamic>;
      return List<Video>.from(data.map((model) => Video.fromJson(model)));
    } catch (error) {
      print(error);
      rethrow;
    }
  }
}
