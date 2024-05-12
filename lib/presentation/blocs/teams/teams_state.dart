
import 'package:flutter_football/domain/models/team.dart';

enum TeamStatus {
  initial,
  loading,
  success,
  error
}

class TeamState {
  final TeamStatus status;
  final List<Team> teams;
  final Team? teamDetail;
  final String error;

  TeamState({
    this.status = TeamStatus.initial,
    this.teams = const [],
    this.teamDetail,
    this.error = '',
  });

  TeamState copyWith({
    TeamStatus? status,
    List<Team>? teams,
    Team? teamDetail,
    String? error,
  }) {
    return TeamState(
      status: status ?? this.status,
      teams: teams ?? this.teams,
      teamDetail: teamDetail ?? this.teamDetail,
      error: error ?? this.error
    );
  }
}