import 'package:intl/intl.dart';

class Match {
  final int id;
  final DateTime date;
  final String opponentName;
  final String place;
  final String idTeam;
  final String? win;
  final String nameTeam;
  final int? idFMI;

  Match({
    required this.id,
    required this.date,
    required this.opponentName,
    required this.place,
    required this.idTeam,
    this.win,
    required this.nameTeam,
    this.idFMI,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    try {
      final int id = json["id"] as int;
      final DateTime date =
          DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json["date"]);
      final String opponentName = json["opponentName"] as String;
      final String place = json["place"] as String;
      final String idTeam = json["idTeam"].toString();
      final String? win = json["win"] as String?;
      final String nameTeam = json["nameTeam"] as String? ?? "";
      final int? idFMI = json["idFMI"] as int?;

      return Match(
          id: id,
          date: date,
          opponentName: opponentName,
          place: place,
          idTeam: idTeam,
          win: win,
          nameTeam: nameTeam,
          idFMI: idFMI,
      );
    } catch (e) {
      print(e);
      throw const FormatException('Failed to convert Match data.');
    }
  }
}
