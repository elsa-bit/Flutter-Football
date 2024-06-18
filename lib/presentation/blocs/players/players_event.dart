abstract class PlayersEvent {}

class GetPlayersTeam extends PlayersEvent {
  final String teamId;

  GetPlayersTeam({required this.teamId});
}

class GetPlayerDetails extends PlayersEvent {
  GetPlayerDetails();
}
