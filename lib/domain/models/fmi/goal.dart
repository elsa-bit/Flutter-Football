import 'package:flutter_football/domain/models/fmi/player_short_info.dart';
import 'package:intl/intl.dart';

class Goal {
  final int id;
  final DateTime createdAt;
  final bool fromOpponent;
  final PlayerShortInfo? player;

  Goal(this.id, this.createdAt, this.fromOpponent, this.player);

  factory Goal.fromJson(Map<String, dynamic> json) {
    try {
      final int id = json["id"] as int;
      final DateTime createdAt =
      DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json["created_at"]);
      final bool fromOpponent = json["fromOpponent"] as bool;
      final playerData = json["player"] as Map<String, dynamic>?;
      final PlayerShortInfo? player = (playerData != null) ? PlayerShortInfo.fromJson(playerData!) : null;

      return Goal(id, createdAt, fromOpponent, player);
    } catch (e) {
      print(e);
      throw const FormatException('Failed to convert Goal data.');
    }
  }
}