
import 'package:flutter_football/domain/models/player.dart';

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

class GetTeamPlayers extends TeamsEvent {
  final List<Player> players;

  GetTeamPlayers({
    required this.players
  });
}