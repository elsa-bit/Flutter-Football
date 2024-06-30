import 'package:flutter_football/domain/models/fmi/player_short_info.dart';
import 'package:intl/intl.dart';

class Replacement {
  final int id;
  final DateTime createdAt;
  final int idMatch;
  final PlayerShortInfo playerIn;
  final PlayerShortInfo playerOut;
  final String? reason;

  Replacement(this.id, this.createdAt, this.idMatch, this.playerIn, this.playerOut, this.reason);

  factory Replacement.fromJson(Map<String, dynamic> json) {
    try {
      final int id = json["id"] as int;
      final DateTime createdAt =
      DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json["created_at"]);
      final int idMatch = json["idMatch"] as int;
      final PlayerShortInfo playerIn = PlayerShortInfo.fromJson(json["playerIn"] as Map<String, dynamic>);
      final PlayerShortInfo playerOut = PlayerShortInfo.fromJson(json["playerOut"] as Map<String, dynamic>);
      final String? reason = json["reason"] as String?;

      return Replacement(id, createdAt, idMatch, playerIn, playerOut, reason);
    } catch (e) {
      print(e);
      throw const FormatException('Failed to convert Replacement data.');
    }
  }
}