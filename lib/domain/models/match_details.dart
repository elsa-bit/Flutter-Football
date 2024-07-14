import 'dart:ui';

import 'package:flutter_football/config/app_colors.dart';
import 'package:intl/intl.dart';

class MatchDetails {
  final int id;
  int teamGoals;
  int opponentGoals;
  final DateTime date;
  final String opponentName;
  final String place;
  final String idTeam;
  final String? win;
  final String nameTeam;
  final List<String>? playerSelection;
  final bool FMICompleted;

  MatchDetails({
    required this.id,
    required this.teamGoals,
    required this.opponentGoals,
    required this.date,
    required this.opponentName,
    required this.place,
    required this.idTeam,
    this.win,
    required this.nameTeam,
    required this.playerSelection,
    required this.FMICompleted,
  });

  factory MatchDetails.fromJson(Map<String, dynamic> json) {
    try {
      final int id = json["id"] as int;
      final int opponentGoals = json["opponentGoals"] as int;
      final int teamGoals = json["teamGoals"] as int;
      final DateTime date =
      DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json["date"]);
      final String opponentName = json["opponentName"] as String;
      final String place = json["place"] as String;
      final String idTeam = json["idTeam"].toString();
      final String? win = json["win"] as String?;
      final String nameTeam = json["nameTeam"] as String? ?? "";
      final selectionJson = json["selection"] as List<dynamic>?;
      final List<String>? selection = selectionJson?.map((e) => e as String).toList();
      final bool FMICompleted = json["FMICompleted"] as bool;

      return MatchDetails(
        id: id,
        opponentGoals: opponentGoals,
        teamGoals: teamGoals,
        date: date,
        opponentName: opponentName,
        place: place,
        idTeam: idTeam,
        win: win,
        nameTeam: nameTeam,
        playerSelection: selection,
        FMICompleted: FMICompleted,
      );
    } catch (e) {
      print(e);
      throw const FormatException('Failed to convert MatchDetails data.');
    }
  }

  MatchDetails copyWith({
    int? teamGoals,
    int? opponentGoals,
  }) {
    return
      MatchDetails(
        id: this.id,
        teamGoals: teamGoals ?? this.teamGoals,
        opponentGoals: opponentGoals ?? this.opponentGoals,
        date: this.date,
        opponentName: this.opponentName,
        place: this.place,
        idTeam: this.idTeam,
        win: this.win,
        nameTeam: this.nameTeam,
        playerSelection: this.playerSelection,
        FMICompleted: this.FMICompleted,
      );
  }

  Color? getMatchStateColor() {
    if (win == "win") {
      return AppColors.green.withOpacity(0.4);
    }
    if (win == "lose") {
      return AppColors.red.withOpacity(0.4);
    }
    if (win == "nul") {
      return AppColors.orange.withOpacity(0.4);
    }
    return AppColors.black.withOpacity(0.1);
  }

  String? getMatchState() {
    if (win == "win") {
      return "Victoire";
    }
    if (win == "lose") {
      return "Défaite";
    }
    if (win == "nul") {
      return "Egualité";
    }
    return null;
  }
}
