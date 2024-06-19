import 'package:flutter_football/data/services/player_service.dart';
import 'package:flutter_football/domain/models/player.dart';

enum PlayersStatus { initial, loading, success, error }

class PlayersState {
  final PlayersStatus status;
  final List<Player>? players;
  final Player? detailsPlayer;
  final String error;

  PlayersState({
    this.status = PlayersStatus.initial,
    this.players = const [],
    this.detailsPlayer = null,
    this.error = '',
  });

  PlayersState copyWith({
    PlayersStatus? status,
    List<Player>? players,
    Player? detailsPlayer,
    String? error,
  }) {
    return PlayersState(
        status: status ?? this.status,
        players: players ?? this.players,
        detailsPlayer: detailsPlayer ?? this.detailsPlayer,
        error: error ?? this.error);
  }
}
