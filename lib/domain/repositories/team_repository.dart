
import 'dart:convert';

import 'package:flutter_football/data/data_sources/team_data_source.dart';

import '../models/team.dart';

class TeamRepository {
  final TeamDataSource teamDataSource;

  TeamRepository({
    required this.teamDataSource,
  });

  Future<List<Team>> getCoachTeams(String coachId) async {
    try {
      final teams = await teamDataSource.getCoachTeams(coachId);
      final data = jsonDecode(teams) as Map<String, dynamic>;
      return List<Team>.from(data.values.map((model)=> Team.fromJson(model)));
    } catch(error) {
      rethrow;
    }
  }

  Future<Team> getTeam(int teamId) async {
    try {
      final team = await teamDataSource.getTeam(teamId);
      return Team.fromJson(jsonDecode(team) as Map<String, dynamic>);
    } catch(error) {
      rethrow;
    }
  }


}