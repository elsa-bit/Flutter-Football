import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_football/data/data_sources/base_data_source.dart';
import 'package:flutter_football/data/services/player_service.dart';
import 'package:flutter_football/domain/models/player.dart';
import 'package:flutter_football/domain/models/player_min.dart';
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
      throw ExceptionsFactory()
          .handleStatusCode(response.statusCode, errorMessage: errorMessage);
    }
  }

  @override
  Future<Player> getPlayerDetails(int idplayer) async {
    final queryParameters = {'idplayer': idplayer.toString()};
    final response =
        await httpGet(Endpoints.detailsPlayerPath, queryParameters);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)["info"] as Map<String, dynamic>;
      return Player.fromJson(data);
    } else {
      final errorMessage = response.body;
      throw ExceptionsFactory()
          .handleStatusCode(response.statusCode, errorMessage: errorMessage);
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
      throw ExceptionsFactory()
          .handleStatusCode(response.statusCode, errorMessage: errorMessage);
    }
  }

  @override
  Future<String> getFriendsPlayer(String idplayer) async {
    final queryParameters = {'idplayer': idplayer};
    final response = await httpGet(Endpoints.friendPlayerPath, queryParameters);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      final errorMessage = response.body;
      throw ExceptionsFactory()
          .handleStatusCode(response.statusCode, errorMessage: errorMessage);
    }
  }

  @override
  Future<String> modifyPlayer(PlayerMin player, int idPlayer) async {
    final body = {
      'id': idPlayer,
      'email': player.email,
      'password': player.password,
      'position': player.position,
      'birthday': player.birthday,
    };

    final response = await httpPostBody(Endpoints.modifyPlayerPath, body);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      final errorMessage = response.body;
      throw ExceptionsFactory()
          .handleStatusCode(response.statusCode, errorMessage: errorMessage);
    }
  }

  @override
  Future<String> getCoachPlayer(String idteams) async {
    final queryParameters = {'idteams': idteams};
    final response = await httpGet(Endpoints.coachPlayerPath, queryParameters);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      final errorMessage = response.body;
      throw ExceptionsFactory()
          .handleStatusCode(response.statusCode, errorMessage: errorMessage);
    }
  }
}
