import 'package:flutter/cupertino.dart';

class Training {
  final int id;
  final DateTime date;
  final String place;
  final String nameTeam;
  //final String? presence;

  Training({
    required this.id,
    required this.date,
    required this.place,
    required this.nameTeam
    //this.presence,
  });

  factory Training.fromJson(Map<String, dynamic> json) {
    try {
      final int id = json["id"] as int;
      final DateTime date = DateTime.parse(json["date"] as String);
      final String place = json["place"] as String;
      final String nameTeam = json["nameTeam"] as String;
      //final String? presence = json["presence"] as String;

      return Training(id: id, date: date, place: place, nameTeam: nameTeam);
    } catch (e) {
      print(e);
      throw const FormatException('Failed to convert Training data.');
    }
  }
}
