abstract class TeamService {
  Future<String> getCoachTeams(String coachId);
  Future<String> getTeam(int teamId);
}