abstract class TeamService {
  Future<String> getCoachTeams(String coachId);
  Future<String> getTeam(int teamId);
  Future<String> getTeamPlayers(int teamId);
}