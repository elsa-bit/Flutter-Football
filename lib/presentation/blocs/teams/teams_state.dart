
import 'package:flutter_football/domain/models/player.dart';
import 'package:flutter_football/domain/models/team.dart';

enum TeamStatus {
  initial,
  loading,
  success,
  error
}

class TeamState {
  final TeamStatus status;
  final List<Team>? teams;
  final Team? teamDetail;
  final List<Player>? players;
  final String error;

  TeamState({
    this.status = TeamStatus.initial,
    this.teams = const [],
    this.teamDetail,
    this.players = const [],
    this.error = '',
  });

  TeamState copyWith({
    TeamStatus? status,
    List<Team>? teams,
    Team? teamDetail,
    List<Player>? players,
    String? error,
  }) {
    return TeamState(
      status: status ?? this.status,
      teams: teams ?? this.teams,
      teamDetail: teamDetail ?? this.teamDetail,
      players: players ?? this.players,
      error: error ?? this.error
    );
  }
}