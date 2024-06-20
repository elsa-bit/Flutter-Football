import 'dart:convert';

import 'package:flutter_football/data/data_sources/player_data_source.dart';
import 'package:flutter_football/data/data_sources/shared_preferences_data_source.dart';
import 'package:flutter_football/data/services/player_service.dart';
import 'package:flutter_football/domain/models/player.dart';
import 'package:flutter_football/domain/models/player_min.dart';

import '../models/team.dart';

class PlayerRepository {
  final PlayerDataSource playerDataSource;
  SharedPreferencesDataSource preferencesDataSource;

  PlayerRepository({
    required this.playerDataSource,
    required this.preferencesDataSource,
  });

  Future<List<Player>> getPlayersTeams(String teamId) async {
    try {
      final players = await playerDataSource.getPlayersTeam(teamId);
      final data = jsonDecode(players)["players"] as List<dynamic>;
      return List<Player>.from(data.map((model) => Player.fromJson(model)));
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<Player> getPlayerDetails() async {
    final idPlayer = preferencesDataSource.getIdPlayer();

    try {
      final detailsPlayer = await playerDataSource.getPlayerDetails(idPlayer!);
      return detailsPlayer;
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<String> addFriend(String idPlayer, String idFriend) {
    return playerDataSource.addFriend(idPlayer, idFriend);
  }

  Future<List<Player>> getFriendsPlayer(String idPlayer) async {
    try {
      final players = await playerDataSource.getFriendsPlayer(idPlayer);
      final data = jsonDecode(players)["player"] as List<dynamic>;
      return List<Player>.from(data.map((model) => Player.fromJson(model)));
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<String> modifyPlayer(PlayerMin player) {
    final idPlayer = preferencesDataSource.getIdPlayer();

    return playerDataSource.modifyPlayer(player, idPlayer!);
  }
}
