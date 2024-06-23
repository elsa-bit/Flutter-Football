import 'package:flutter_football/data/services/player_service.dart';
import 'package:flutter_football/domain/models/player.dart';
import 'package:flutter_football/domain/models/user.dart';

enum PlayersStatus { initial, loading, success, error }

class PlayersState {
  final PlayersStatus status;
  final List<Player>? players;
  final Player? detailsPlayer;
  final List<Coach>? coachs;
  final String error;

  PlayersState({
    this.status = PlayersStatus.initial,
    this.players = const [],
    this.detailsPlayer = null,
    this.coachs = const [],
    this.error = '',
  });

  PlayersState copyWith({
    PlayersStatus? status,
    List<Player>? players,
    Player? detailsPlayer,
    List<Coach>? coachs,
    String? error,
  }) {
    return PlayersState(
        status: status ?? this.status,
        players: players ?? this.players,
        detailsPlayer: detailsPlayer ?? this.detailsPlayer,
        coachs: coachs ?? this.coachs,
        error: error ?? this.error);
  }
}
