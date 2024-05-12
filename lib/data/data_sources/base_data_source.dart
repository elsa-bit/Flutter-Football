import 'dart:io';
import 'package:http/http.dart' as http;

class BaseDataSource {

  Future<http.Response> httpGet(String url) async {
    return await http.get(
      Uri.parse(url),
      // Send authorization headers to the backend.
      /*headers: {
        HttpHeaders.authorizationHeader: 'Basic your_api_token_here',
      },*/
    );
  }


}