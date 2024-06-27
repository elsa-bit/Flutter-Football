import 'package:flutter_football/domain/models/fmi/player_short_info.dart';
import 'package:intl/intl.dart';

class Card {
  final int id;
  final DateTime createdAt;
  final String color;
  final PlayerShortInfo player;

  Card(this.id, this.createdAt, this.color, this.player);

  factory Card.fromJson(Map<String, dynamic> json) {
    try {
      final int id = json["id"] as int;
      final DateTime createdAt =
      DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json["created_at"]);
      final String color = json["color"] as String;
      final PlayerShortInfo player = PlayerShortInfo.fromJson(json["player"] as Map<String, dynamic>);

      return Card(id, createdAt, color, player);
    } catch (e) {
      print(e);
      throw const FormatException('Failed to convert Card data.');
    }
  }
}

