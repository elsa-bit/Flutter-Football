import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_football/networking/endpoints.dart';
import 'package:flutter_football/networking/exceptions_factory.dart';

import 'base_data_source.dart';

class AuthDataSource extends BaseDataSource {
  Future<List<dynamic>> getPlayerAccess(String idplayer) async {
    final queryParameters = {'idplayer': idplayer};

    final response = await httpGet(Endpoints.accessPlayerPath, queryParameters);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)["accessTeams"] as List<dynamic>;
      print(data);
      return data;
    } else {
      final errorMessage = response.body;
      throw ExceptionsFactory()
          .handleStatusCode(response.statusCode, errorMessage: errorMessage);
    }
  }

  Future<void> logout(String idUser, String mode) async {
    final queryParameters = {'iduser': idUser, 'mode': mode};
    await httpPost(Endpoints.logout, queryParameters);
  }
}
