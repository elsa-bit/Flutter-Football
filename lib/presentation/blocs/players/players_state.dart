import 'package:flutter_football/domain/models/player.dart';

enum PlayersStatus { initial, loading, success, error }

class PlayersState {
  final PlayersStatus status;
  final List<Player> players;
  final String error;

  PlayersState({
    this.status = PlayersStatus.initial,
    this.players = const [],
    this.error = '',
  });

  PlayersState copyWith({
    PlayersStatus? status,
    List<Player>? players,
    String? error,
  }) {
    return PlayersState(
        status: status ?? this.status,
        players: players ?? this.players,
        error: error ?? this.error);
  }
}
