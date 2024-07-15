import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../networking/endpoints.dart';

class BaseDataSource {
  Future<http.Response> httpGet(String path,
      [Map<String, String>? queryParameters]) async {
    var uri = Uri.https(Endpoints.baseURL, path, queryParameters);
    return await http.get(
      uri,
    );
  }

  Future<http.Response> httpPost(String path,
      [Map<String, String?>? query, String? body]) {
    final uri = Uri.https(Endpoints.baseURL, path, query);
    print(uri);
    return http.post(
      uri,
      body: body,
    );
  }

  Future<http.Response> httpPostBody(String path, Map<String, dynamic> body) {
    final uri = Uri.https(Endpoints.baseURL, path);
    print(uri);
    return http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );
  }
}
