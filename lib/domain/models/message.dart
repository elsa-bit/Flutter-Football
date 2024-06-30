import 'package:intl/intl.dart';

class Message {
  final int? id;
  final DateTime? date;
  final int idConversation;
  final String message;
  final int idSender;
  final String role;
  final String? sender;

  Message(
      {this.id,
      this.date,
      required this.idConversation,
      required this.message,
      required this.idSender,
      required this.role,
      this.sender});

  factory Message.fromJson(Map<String, dynamic> json) {
    try {
      final int? id = json["id"] as int?;
      final DateTime date =
          DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json["created_at"]);
      final int idConversation = json["idConversation"] as int;
      final String message = json["message"] as String;
      final int idSender = json["idSender"] as int;
      final String role = json["role"] as String;
      final String? sender = json["sender"] as String?;

      return Message(
          id: id,
          date: date,
          idConversation: idConversation,
          message: message,
          idSender: idSender,
          role: role,
          sender: sender);
    } catch (e) {
      print(e);
      throw const FormatException('Failed to convert Message data.');
    }
  }
}
