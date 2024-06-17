import 'package:flutter_football/domain/models/event.dart';
import 'package:flutter_football/domain/models/meeting.dart';
import 'package:flutter_football/domain/models/training.dart';
import 'package:flutter_football/domain/models/match.dart';

abstract class ScheduleService {
  Future<ScheduleResult> getSchedule(int idcoach, String idteams);

  Future<ScheduleResultPlayer> getSchedulePlayer(int idcoach);

  Future<String> addSchedule(Event event, DateTime date);
}

class ScheduleResult {
  final List<Match> matchs;
  final List<Training> trainings;
  final List<Meeting> meetings;

  ScheduleResult({
    required this.matchs,
    required this.trainings,
    required this.meetings,
  });

  factory ScheduleResult.fromJson(Map<String, dynamic> json) {
    return ScheduleResult(
      matchs: json['matchs'] != null
          ? (json['matchs'] as List).map((e) => Match.fromJson(e)).toList()
          : [],
      trainings: json['trainings'] != null
          ? (json['trainings'] as List)
              .map((e) => Training.fromJson(e))
              .toList()
          : [],
      meetings: json['meetings'] != null
          ? (json['meetings'] as List).map((e) => Meeting.fromJson(e)).toList()
          : [],
    );
  }
}

class ScheduleResultPlayer {
  final List<Match> matchs;
  final List<Training> trainings;
  final String idTeams;

  ScheduleResultPlayer({
    required this.matchs,
    required this.trainings,
    required this.idTeams,
  });

  factory ScheduleResultPlayer.fromJson(Map<String, dynamic> json) {
    return ScheduleResultPlayer(
      matchs: json['matchs'] != null
          ? (json['matchs'] as List).map((e) => Match.fromJson(e)).toList()
          : [],
      trainings: json['trainings'] != null
          ? (json['trainings'] as List)
              .map((e) => Training.fromJson(e))
              .toList()
          : [],
      idTeams: json['idTeams'] as String,
    );
  }
}
