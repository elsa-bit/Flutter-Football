import 'package:flutter_football/domain/models/player.dart';

abstract class PlayerService {
  Future<String> getPlayersTeam(String idteam);

  Future<PlayerDetailResult> getPlayerDetails(int idplayer);
}

class PlayerDetailResult {
  final Player player;
  final int goal;
  final int redCard;
  final int yellowCard;

  PlayerDetailResult({
    required this.player,
    required this.goal,
    required this.redCard,
    required this.yellowCard,
  });

  factory PlayerDetailResult.fromJson(Map<String, dynamic> json) {
    return PlayerDetailResult(
      player: Player.fromJson(json['info'] as Map<String, dynamic>),
      goal: json['goal'] as int,
      redCard: json['redCard'] as int,
      yellowCard: json['yellowCard'] as int,
    );
  }
}
