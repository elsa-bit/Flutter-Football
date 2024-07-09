import 'package:flutter_football/domain/models/match_details.dart';

enum MatchStatus { initial, loading, success, error, refresh, redirect }

class MatchError extends Error {
  final String message;

  MatchError(this.message);
}

class FMICreationError extends MatchError {
  FMICreationError(super.message);
}

class FMICardCreationException extends MatchError {
  FMICardCreationException(super.message);
}

class FMIGoalCreationException extends MatchError {
  FMIGoalCreationException(super.message);
}

class FMIReplacementCreationException extends MatchError {
  FMIReplacementCreationException(super.message);
}

class MatchSelectionException extends MatchError {
  MatchSelectionException(super.message);
}

class FMIActionsException extends MatchError {
  FMIActionsException(super.message);
}


class MatchState {
  final MatchStatus status;
  final List<MatchDetails>? previousMatch;
  final List<MatchDetails>? nextMatch;
  final List<String>? playerSelection;
  final String? idTeams;
  final MatchError? error;
  final MatchDetails? redirection;

  MatchState({
    this.status = MatchStatus.initial,
    this.previousMatch = null,
    this.nextMatch = null,
    this.playerSelection = null,
    this.idTeams = '',
    this.error = null,
    this.redirection = null,
  });

  MatchState copyWith({
    MatchStatus? status,
    final List<MatchDetails>? previousMatch,
    final List<MatchDetails>? nextMatch,
    final List<String>? playerSelection,
    final String? idTeams,
    MatchError? error,
    MatchDetails? redirection,
  }) {
    return MatchState(
        status: status ?? this.status,
        previousMatch: previousMatch ?? this.previousMatch,
        nextMatch: nextMatch ?? this.nextMatch,
        playerSelection: playerSelection ?? this.playerSelection,
        idTeams: idTeams ?? this.idTeams,
        error: error ?? this.error,
      redirection: redirection,
    );
  }
}
