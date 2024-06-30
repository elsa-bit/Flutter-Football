import 'package:flutter_football/domain/models/match_details.dart';

enum MatchStatus { initial, loading, success, error }

class MatchState {
  final MatchStatus status;
  final List<MatchDetails>? previousMatch;
  final List<MatchDetails>? nextMatch;
  final String? idTeams;
  final String error;

  MatchState({
    this.status = MatchStatus.initial,
    this.previousMatch = null,
    this.nextMatch = null,
    this.idTeams = '',
    this.error = '',
  });

  MatchState copyWith({
    MatchStatus? status,
    final List<MatchDetails>? previousMatch,
    final List<MatchDetails>? nextMatch,
    final String? idTeams,
    String? error,
  }) {
    return MatchState(
        status: status ?? this.status,
        previousMatch: previousMatch ?? this.previousMatch,
        nextMatch: nextMatch ?? this.nextMatch,
        idTeams: idTeams ?? this.idTeams,
        error: error ?? this.error);
  }
}
