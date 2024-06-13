import 'package:flutter/cupertino.dart';

class Match {
  final int id;
  final int opponentGoal;
  final DateTime date;
  final String opponentName;
  final String place;
  final bool? win;
  final String nameTeam;

  Match(
      {required this.id,
      required this.opponentGoal,
      required this.date,
      required this.opponentName,
      required this.place,
      this.win,
      required this.nameTeam});

  factory Match.fromJson(Map<String, dynamic> json) {
    try {
      final int id = json["id"] as int;
      final int opponentGoal = json["opponentGoal"] as int;
      final DateTime date = DateTime.parse(json["date"] as String);
      final String opponentName = json["opponentName"] as String;
      final String place = json["place"] as String;
      final bool? win = json["win"] as bool?;
      final String nameTeam = json["nameTeam"] as String;

      return Match(
          id: id,
          opponentGoal: opponentGoal,
          date: date,
          opponentName: opponentName,
          place: place,
          win: win,
          nameTeam: nameTeam);
    } catch (e) {
      print(e);
      throw const FormatException('Failed to convert Match data.');
    }
  }
}
