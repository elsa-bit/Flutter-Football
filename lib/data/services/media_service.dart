import 'dart:typed_data';

abstract class MediaService {
  Future<String> getAvatar(String name);

  Future<String> getDefaultAvatar();

  Future<String> getClubRule();
}
