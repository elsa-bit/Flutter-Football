import 'package:intl/intl.dart';

class Training {
  final int id;
  final DateTime date;
  final String place;
  final String idTeam;
  final String nameTeam;
  final List<dynamic>? presence;

  Training(
      {required this.id,
      required this.date,
      required this.place,
      required this.idTeam,
      required this.nameTeam,
      this.presence,
      });

  factory Training.fromJson(Map<String, dynamic> json) {
    try {
      final int id = json["id"] as int;
      final DateTime date =
          DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json["date"]);
      final String place = json["place"] as String;
      final String idTeam = json["idTeam"].toString();
      final String nameTeam = json["nameTeam"] as String;
      final List<dynamic>? presence = json["presence"] as List<dynamic>?;

      return Training(
          id: id, date: date, place: place, idTeam: idTeam, nameTeam: nameTeam, presence: presence);
    } catch (e) {
      print(e);
      throw const FormatException('Failed to convert Training data.');
    }
  }
}
