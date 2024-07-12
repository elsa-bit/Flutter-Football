import 'dart:io';

import 'package:flutter_football/data/data_sources/base_data_source.dart';
import 'package:flutter_football/data/services/media_service.dart';
import 'package:flutter_football/main.dart';
import 'package:flutter_football/networking/endpoints.dart';
import 'package:flutter_football/networking/exceptions_factory.dart';
import 'package:flutter_football/presentation/blocs/media/media_state.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

class MediaDataSource extends BaseDataSource with MediaService {
  @override
  Future<String> getAvatar(String name) async {
    return await supabase.storage.from('avatars').createSignedUrl(name, 300);
  }

  @override
  Future<String> getDefaultAvatar() async {
    return await supabase.storage
        .from('default')
        .getPublicUrl('default_profile.jpg');
  }

  Future<String> getClubRule() async {
    return await supabase.storage.from('rule').createSignedUrl('club_rule.pdf', 240);
  }

  Future<String> getCoachRule() async {
    return await supabase.storage.from('rule').createSignedUrl('coach_rule.pdf', 160);
  }

  Future<String> getDocumentClub() async {
    return await supabase.storage.from('rule').createSignedUrl('doc_club.pdf', 160);
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

  Future<List<String>> getMatchBucketImages(String matchId) async {
    final result = await supabase.storage.from("match-resources").list(path: matchId);

    if (result.isEmpty) {
      throw Exception('No files found in the bucket');
    }

    List<String> imageUrls = [];
    for (var file in result) {
      try {
        String url = await supabase.storage.from('match-resources')
            .createSignedUrl("$matchId/${file.name}", 7200); // 7200 secondes = 2 hours
        imageUrls.add(url);
      } catch (e) {
        print("Failed to create signed url for file ${file.name}. $e");
      }
     }
    return imageUrls;
  }

  Future<String> getSpecificVideos(String idplayer) async {
    final queryParameters = {'idplayer': idplayer};
    final response = await httpGet(Endpoints.specificVideosPlayerPath, queryParameters);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      final errorMessage = response.body;
      throw ExceptionsFactory()
          .handleStatusCode(response.statusCode, errorMessage: errorMessage);
    }
  }

  Future<void> updateProfilePicture(File imageFile, String filename) async {
    var request = MultipartRequest(
        'POST',
        Uri.https(Endpoints.baseURL, Endpoints.updateProfilePicturePath)
    );

    // Add the file to the request
    request.files.add(
        await MultipartFile.fromPath(
            'file',
            imageFile.path,
          filename: filename,
          contentType: MediaType('image', 'jpg'),
        )
    );


    // Send the request and get the response
    var response = await request.send();
    print(response);
    print(response.statusCode);
    print(response.toString());
    return;
  }
}
