import 'package:flutter_football/domain/models/match_details.dart';
import 'package:flutter_football/domain/models/player.dart';
import 'package:flutter_football/domain/models/team.dart';

enum TeamStatus { initial, loading, historyLoading, success, error }

class TeamState {
  final TeamStatus status;
  final List<Team>? teams;
  final Team? teamDetail;
  final List<Player>? players;
  final List<MatchDetails>? teamMatches;
  final int wins;
  final int nuls;
  final int loses;
  final String error;

  TeamState({
    this.status = TeamStatus.initial,
    this.teams = const [],
    this.teamDetail,
    this.players = const [],
    this.teamMatches = const [],
    this.wins = 0,
    this.nuls = 0,
    this.loses = 0,
    this.error = '',
  });

  TeamState copyWith({
    TeamStatus? status,
    List<Team>? teams,
    Team? teamDetail,
    List<Player>? players,
    List<MatchDetails>? teamMatches,
    String? error,
    int? wins,
    int? nuls,
    int? loses,
  }) {
    return TeamState(
      status: status ?? this.status,
      teams: teams ?? this.teams,
      teamDetail: teamDetail ?? this.teamDetail,
      players: players ?? this.players,
      teamMatches: teamMatches ?? this.teamMatches,
      error: error ?? this.error,
      wins: wins ?? this.wins,
      nuls: nuls ?? this.nuls,
      loses: loses ?? this.loses,
    );
  }
}
