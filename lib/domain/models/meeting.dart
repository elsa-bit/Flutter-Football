import 'package:intl/intl.dart';

class Meeting {
  final int id;
  final DateTime date_debut;
  final String name;

  Meeting({
    required this.id,
    required this.date_debut,
    required this.name,
  });

  factory Meeting.fromJson(Map<String, dynamic> json) {
    try {
      final int id = json["id"] as int;
      final DateTime date_debut =
          DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json["date_debut"]);
      final String name = json["name"] as String;

      return Meeting(id: id, date_debut: date_debut, name: name);
    } catch (e) {
      print(e);
      throw const FormatException('Failed to convert Meeting data.');
    }
  }
}
