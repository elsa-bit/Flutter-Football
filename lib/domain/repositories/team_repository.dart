
import 'dart:convert';

import 'package:flutter_football/data/data_sources/shared_preferences_data_source.dart';
import 'package:flutter_football/data/data_sources/team_data_source.dart';
import 'package:flutter_football/domain/models/player.dart';

import '../models/team.dart';

class TeamRepository {
  final TeamDataSource teamDataSource;
  final SharedPreferencesDataSource preferences;

  TeamRepository({
    required this.teamDataSource,
    required this.preferences,
  });

  Future<List<Team>> getCoachTeams() async {
    try {
      final coachID = preferences.getIdCoach();
      if(coachID == null) {
        return [];
      }

      final teams = await teamDataSource.getCoachTeams(coachID);
      final data = jsonDecode(teams)["teams"] as List<dynamic>;
      final result = List<Team>.from(data.map((model)=> Team.fromJson(model)));
      preferences.saveTeamsIds(result.map((e) => e.id).toList());
      return result;
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