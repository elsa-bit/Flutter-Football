import 'dart:convert';

import 'package:flutter_football/data/data_sources/player_data_source.dart';
import 'package:flutter_football/data/data_sources/shared_preferences_data_source.dart';
import 'package:flutter_football/data/data_sources/team_data_source.dart';
import 'package:flutter_football/data/services/player_service.dart';
import 'package:flutter_football/domain/models/player.dart';

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

  Future<PlayerDetailResult> getPlayerDetails() async {
    final idPlayer = preferencesDataSource.getIdPlayer();

    try {
      final detailsPlayer = await playerDataSource.getPlayerDetails(idPlayer!);
      return detailsPlayer;
    } catch (error) {
      print(error);
      rethrow;
    }
  }
}
