abstract class TeamService {
  Future<String> getCoachTeams(int coachId);
  Future<String> getTeam(int teamId);
  Future<String> getTeamPlayers(int teamId);
  Future<String> getSpecificTeamPlayer(String idplayer);
}