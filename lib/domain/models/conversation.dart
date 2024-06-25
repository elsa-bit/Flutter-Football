import 'package:intl/intl.dart';

class Conversation {
  final int id;
  final DateTime date;
  final List<dynamic> players;
  final String coach;

  Conversation(
      {required this.id,
      required this.date,
      required this.players,
      required this.coach});

  factory Conversation.fromJson(Map<String, dynamic> json) {
    try {
      final int id = json["id"] as int;
      final DateTime date =
          DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json["updated_at"]);
      final List<dynamic> players = json["players"] as List<dynamic>;
      final String coach = json["coach"] as String;

      return Conversation(id: id, date: date, players: players, coach: coach);
    } catch (e) {
      print(e);
      throw const FormatException('Failed to convert Conversation data.');
    }
  }
}
