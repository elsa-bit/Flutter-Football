import 'package:http/http.dart' as http;
import '../../networking/endpoints.dart';

class BaseDataSource {

  Future<http.Response> httpGet(String path, [Map<String, String>? queryParameters]) async {
    var uri = Uri.http(Endpoints.baseURL, path, queryParameters);
    return await http.get(
      uri,
      // Send authorization headers to the backend.
      /*headers: {
        HttpHeaders.authorizationHeader: 'Basic your_api_token_here',
      },*/
    );
  }

  /*
  body = jsonEncode(<String, String>{
        'title': title,
      })
   */
  Future<http.Response> httpPost(String path, String body) {
    return http.post(
      Uri.http(Endpoints.baseURL, path),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );
  }

}