abstract class PlayersEvent {}

class GetPlayersTeam extends PlayersEvent {
  final String teamId;

  GetPlayersTeam({required this.teamId});
}

class GetPlayerDetails extends PlayersEvent {
  GetPlayerDetails();
}

class GetFriendsPlayer extends PlayersEvent {
  final String idPlayer;

  GetFriendsPlayer({required this.idPlayer});
}

class AddFriend extends PlayersEvent {
  final String idPlayer;
  final String idFriend;

  AddFriend({
    required this.idPlayer,
    required this.idFriend,
  });
}

class Search extends PlayersEvent {
  final String search;

  Search({
    required this.search,
  });
}
