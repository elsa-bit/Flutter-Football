import 'package:flutter_football/domain/models/fmi/match_action.dart';
import 'package:flutter_football/domain/models/match_details.dart';
import 'package:flutter_football/domain/models/player.dart';

enum FmiStatus { initial, loading, loadingHistory, loadingPlayer, success, error }

class FmiState {
  final FmiStatus status;
  final String error;
  final MatchDetails? match;
  final List<MatchAction>? actions;
  final List<Player>? playersInGame;
  final List<Player>? playersInReplacement;
  final List<Player>? playerSearch;

  FmiState({
    this.status = FmiStatus.initial,
    this.error = '',
    this.match = null,
    this.actions = null,
    this.playersInGame = null,
    this.playersInReplacement = null,
    this.playerSearch = null,
  });

  FmiState copyWith({
    FmiStatus? status,
    String? error,
    MatchDetails? match,
    List<MatchAction>? actions,
    MatchAction? action,
    List<Player>? playersInGame,
    List<Player>? playersInReplacement,
    List<Player>? playerSearch,
  }) {
    return FmiState(
      status: status ?? this.status,
      error: error ?? this.error,
      match: match ?? this.match,
      actions: actions ?? ((action != null) ? ((this.actions != null) ? (List.from(this.actions!)..add(action!)) : [action!]) : this.actions),
      playersInGame: playersInGame ?? this.playersInGame,
      playersInReplacement: playersInReplacement ?? this.playersInReplacement,
      playerSearch: playerSearch ?? this.playerSearch,
    );
  }
}
