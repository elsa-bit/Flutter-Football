import 'package:flutter_football/presentation/blocs/media/media_state.dart';

abstract class MediaService {
  Future<String> getAvatar(String name);

  Future<String> getDefaultAvatar();

  Future<String> getClubRule();

  Future<List<Video>> getVideosBucket(String bucketName);
}
