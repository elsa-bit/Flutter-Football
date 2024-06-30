import 'package:flutter_football/data/services/player_service.dart';
import 'package:flutter_football/domain/models/player.dart';
import 'package:flutter_football/domain/models/user.dart';

enum PlayersStatus { initial, loading, success, modifySuccess, error }

class PlayersState {
  final PlayersStatus status;
  final List<Player>? players;
  final List<Player>? playerSearch;
  final Player? detailsPlayer;
  final List<Coach>? coachs;
  final String error;

  PlayersState({
    this.status = PlayersStatus.initial,
    this.players = const [],
    this.playerSearch = null,
    this.detailsPlayer = null,
    this.coachs = const [],
    this.error = '',
  });

  PlayersState copyWith({
    PlayersStatus? status,
    List<Player>? players,
    List<Player>? playerSearch,
    Player? detailsPlayer,
    List<Coach>? coachs,
    String? error,
  }) {
    return PlayersState(
        status: status ?? this.status,
        players: players ?? this.players,
        playerSearch: playerSearch ?? this.playerSearch,
        detailsPlayer: detailsPlayer ?? this.detailsPlayer,
        coachs: coachs ?? this.coachs,
        error: error ?? this.error);
  }
}
