import 'dart:convert';


class AuthRepository {
  //final TeamDataSource teamDataSource;

  AuthRepository(/*{
    required this.teamDataSource,
  }*/);

  /*Future<List<Team>> getCoachTeams(String coachId) async {
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
  }*/


}