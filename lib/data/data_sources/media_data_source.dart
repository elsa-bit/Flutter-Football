import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_football/data/data_sources/base_data_source.dart';
import 'package:flutter_football/data/services/media_service.dart';
import 'package:flutter_football/main.dart';
import 'package:flutter_football/presentation/blocs/media/media_state.dart';

class MediaDataSource extends BaseDataSource with MediaService {
  @override
  Future<String> getAvatar(String name) async {
    return await supabase.storage.from('avatars').createSignedUrl(name, 160);
  }

  @override
  Future<String> getDefaultAvatar() async {
    return await supabase.storage
        .from('default')
        .getPublicUrl('default_profile.jpg');
  }

  Future<String> getClubRule() async {
    return await supabase.storage.from('rule').getPublicUrl('club_rule.pdf');
  }

  Future<List<Video>> getVideosBucket(String bucketName) async {
    final result = await supabase.storage.from(bucketName).list();

    if (result.isEmpty) {
      throw Exception('No files found in the bucket');
    }

    List<Video> videos = [];
    for (var file in result) {
      String url = supabase.storage.from(bucketName).getPublicUrl(file.name);

      videos.add(Video(url: url, name: file.name));
    }
    return videos;
  }
}
