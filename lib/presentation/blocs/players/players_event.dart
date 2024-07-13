import 'package:flutter/cupertino.dart';
import 'package:flutter_football/domain/models/player_min.dart';

abstract class PlayersEvent {}

class GetPlayersTeam extends PlayersEvent {
  final String teamId;

  GetPlayersTeam({required this.teamId});
}

class GetPlayersTeams extends PlayersEvent {
  GetPlayersTeams();
}

class GetPlayerDetails extends PlayersEvent {
  GetPlayerDetails();
}

class Search extends PlayersEvent {
  final String search;

  Search({
    required this.search,
  });
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

class ModifyPlayer extends PlayersEvent {
  final PlayerMin player;

  ModifyPlayer({
    required this.player,
  });
}

class GetCoachPlayer extends PlayersEvent {
  GetCoachPlayer();
}

class SubscribeToPlayer extends PlayersEvent {
  SubscribeToPlayer();
}

class GetNewTrophy extends PlayersEvent {
  final String oldDate;

  GetNewTrophy({required this.oldDate});
}

class ClearPlayerState extends PlayersEvent {
  ClearPlayerState();
}
