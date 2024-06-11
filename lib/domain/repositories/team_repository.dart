
import 'dart:convert';

import 'package:flutter_football/data/data_sources/team_data_source.dart';
import 'package:flutter_football/domain/models/player.dart';

import '../models/team.dart';

class TeamRepository {
  final TeamDataSource teamDataSource;

  TeamRepository({
    required this.teamDataSource,
  });

  Future<List<Team>> getCoachTeams(String coachId) async {
    try {
      final teams = await teamDataSource.getCoachTeams(coachId);
      final data = jsonDecode(teams)["teams"] as List<dynamic>;
      return List<Team>.from(data.map((model)=> Team.fromJson(model)));
    } catch(error) {
      print(error);
      rethrow;
    }
  }

  Future<Team> getTeam(int teamId) async {
    try {
      final team = await teamDataSource.getTeam(teamId);
      final data = jsonDecode(team)["teams"] as List<dynamic>;
      return List<Team>.from(data.map((model)=> Team.fromJson(model))).first;
    } catch(error) {
      print(error);
      rethrow;
    }
  }

  Future<List<Player>> getPlayers(int teamId) async {
    try {
      final players = await teamDataSource.getTeamPlayers(teamId);
      final data = jsonDecode(players)["players"] as List<dynamic>;
      return List<Player>.from(data.map((model)=> Player.fromJson(model)));
    } catch(error) {
      print(error);
      rethrow;
    }
  }


}