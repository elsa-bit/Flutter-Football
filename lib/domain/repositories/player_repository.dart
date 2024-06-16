import 'dart:convert';

import 'package:flutter_football/data/data_sources/player_data_source.dart';
import 'package:flutter_football/data/data_sources/team_data_source.dart';
import 'package:flutter_football/domain/models/player.dart';

import '../models/team.dart';

class PlayerRepository {
  final PlayerDataSource playerDataSource;

  PlayerRepository({
    required this.playerDataSource,
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
}
