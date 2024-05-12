
abstract class TeamsEvent {}

class GetTeams extends TeamsEvent {
  final String coachId;

  GetTeams({
    required this.coachId
  });
}

class GetTeamDetails extends TeamsEvent {
  final int teamId;

  GetTeamDetails({
    required this.teamId
  });
}