import 'dart:typed_data';

import 'package:flutter_football/data/data_sources/media_data_source.dart';
import 'package:flutter_football/presentation/blocs/media/media_state.dart';

class MediaRepository {
  final MediaDataSource mediaDataSource;

  MediaRepository({
    required this.mediaDataSource,
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


}