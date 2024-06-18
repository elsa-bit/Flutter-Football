import 'dart:convert';

import 'package:flutter_football/data/data_sources/base_data_source.dart';
import 'package:flutter_football/data/services/player_service.dart';
import '../../networking/endpoints.dart';
import '../../networking/exceptions_factory.dart';

class PlayerDataSource extends BaseDataSource with PlayerService {
  @override
  Future<String> getPlayersTeam(String idteam) async {
    final queryParameters = {'idteam': idteam};
    final response = await httpGet(Endpoints.playersTeamPath, queryParameters);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      final errorMessage = response.body;
      throw ExceptionsFactory().handleStatusCode(response.statusCode, errorMessage: errorMessage);
    }
  }

  @override
  Future<PlayerDetailResult> getPlayerDetails(int idplayer) async {
    final queryParameters = {'idplayer': idplayer.toString()};
    final response = await httpGet(Endpoints.detailsPlayerPath, queryParameters);
    if (response.statusCode == 200) {
      return PlayerDetailResult.fromJson(jsonDecode(response.body));
    } else {
      final errorMessage = response.body;
      throw ExceptionsFactory().handleStatusCode(response.statusCode, errorMessage: errorMessage);
    }
  }

  @override
  Future<String> addFriend(String idplayer, String idfriend) async {
    final queryParameters = {'idplayer': idplayer, 'idfriend': idfriend};
    final response = await httpPost(Endpoints.addFriendPath, queryParameters);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      final errorMessage = response.body;
      throw ExceptionsFactory().handleStatusCode(response.statusCode, errorMessage: errorMessage);
    }
  }
}
