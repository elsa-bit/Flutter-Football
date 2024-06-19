import 'package:flutter_football/data/data_sources/base_data_source.dart';
import 'package:flutter_football/data/services/media_service.dart';
import 'package:flutter_football/main.dart';

class MediaDataSource extends BaseDataSource with MediaService {

  @override
  Future<String> getAvatar(String name) async {
    return await supabase.storage.from('avatars').createSignedUrl(name, 160);
  }

  @override
  Future<String> getDefaultAvatar() async {
    return await supabase.storage.from('default').getPublicUrl('default_profile.jpg');
  }
}
