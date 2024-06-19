
import 'package:flutter_football/domain/models/player.dart';

abstract class TeamsEvent {}

class GetTeams extends TeamsEvent {
  GetTeams();
}

class GetTeamDetails extends TeamsEvent {
  final int teamId;

  GetTeamDetails({
    required this.teamId
  });
}

class GetTeamPlayers extends TeamsEvent {
  final int teamId;

  GetTeamPlayers({
    required this.teamId
  });
}

class GetSpecificTeamPlayer extends TeamsEvent {
  final String idPlayer;

  GetSpecificTeamPlayer({
    required this.idPlayer
  });
}