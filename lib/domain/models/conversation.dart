import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Conversation {
  final int id;
  DateTime date;
  final List<dynamic> players;
  final int coach;
  final String? coachName;
  final String? playersName;

  Conversation(
      {required this.id,
      required this.date,
      required this.players,
      required this.coach,
      this.coachName,
      this.playersName});

  factory Conversation.fromJson(Map<String, dynamic> json) {
    try {
      final int id = json["id"] as int;
      final DateTime date =
          DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json["updated_at"]);
      final List<dynamic> players = json["players"] as List<dynamic>;
      final int coach = json["coach"] as int;
      final String? coachName = json["coachName"] as String?;
      final String? playersName = json["playersName"] as String?;

      return Conversation(
          id: id,
          date: date,
          players: players,
          coach: coach,
          coachName: coachName,
          playersName: playersName);
    } catch (e) {
      print(e);
      throw const FormatException('Failed to convert Conversation data.');
    }
  }
}

class ConversationEventRealtime {
  final PostgresChangeEvent eventType;
  final Conversation conversation;

  ConversationEventRealtime(
      {required this.eventType, required this.conversation});
}
