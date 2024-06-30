import 'package:flutter_football/data/services/player_service.dart';
import 'package:flutter_football/domain/models/player.dart';

enum PlayersStatus { initial, loading, success, error }

class PlayersState {
  final PlayersStatus status;
  final List<Player>? players;
  final List<Player>? playerSearch;
  final Player? detailsPlayer;
  final String error;

  PlayersState({
    this.status = PlayersStatus.initial,
    this.players = const [],
    this.playerSearch = null,
    this.detailsPlayer = null,
    this.error = '',
  });

  PlayersState copyWith({
    PlayersStatus? status,
    List<Player>? players,
    List<Player>? playerSearch,
    Player? detailsPlayer,
    String? error,
  }) {
    return PlayersState(
        status: status ?? this.status,
        players: players ?? this.players,
        playerSearch: playerSearch ?? this.playerSearch,
        detailsPlayer: detailsPlayer ?? this.detailsPlayer,
        error: error ?? this.error);
  }
}
