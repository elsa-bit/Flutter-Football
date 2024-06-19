import 'package:flutter_football/data/data_sources/media_data_source.dart';

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


}