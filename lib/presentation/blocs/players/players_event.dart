abstract class PlayersEvent {}

class GetPlayersTeam extends PlayersEvent {
  final String teamId;

  GetPlayersTeam({required this.teamId});
}

class GetPlayerDetails extends PlayersEvent {
  GetPlayerDetails();
}

class AddFriend extends PlayersEvent {
  final String idPlayer;
  final String idFriend;

  AddFriend({
    required this.idPlayer,
    required this.idFriend,
  });
}
