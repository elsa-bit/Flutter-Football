import 'package:flutter_football/data/services/login_service.dart';
import 'package:flutter_football/networking/endpoints.dart';
import 'package:flutter_football/networking/exceptions_factory.dart';

import '../base_data_source.dart';

class LoginDataSource extends BaseDataSource with LoginService {

  @override
  Future<String> loginAdmin(String email, String password) async {
    const url = Endpoints.baseURL + Endpoints.loginAdmin;
    final response = await httpGet(url);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return response.body;
    } else {
      throw ExceptionsFactory().handleStatusCode(response.statusCode);
    }
  }

  @override
  Future<String> loginCoach(String email, String password) async {
    throw UnimplementedError();
  }

  @override
  Future<String> loginPlayer(String email, String password) async {
    throw UnimplementedError();
  }

}