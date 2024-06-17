import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_football/data/data_sources/schedule_data_source.dart';
import 'package:flutter_football/data/data_sources/shared_preferences_data_source.dart';
import 'package:flutter_football/data/data_sources/team_data_source.dart';
import 'package:flutter_football/data/services/schedule_service.dart';
import 'package:flutter_football/domain/models/event.dart';

import '../models/team.dart';

class ScheduleRepository {
  final ScheduleDataSource scheduleDataSource;
  SharedPreferencesDataSource preferencesDataSource;

  ScheduleRepository({
    required this.scheduleDataSource,
    required this.preferencesDataSource,
  });

  Future<ScheduleResult> getSchedule() async {
    final idCoach = preferencesDataSource.getIdCoach();
    final teamsId = preferencesDataSource
            .getTeamsIds()
            ?.toString()
            .replaceAll("[", "")
            .replaceAll("]", "") ??
        "";

    try {
      final schedules = await scheduleDataSource.getSchedule(idCoach!, teamsId);
      return schedules;
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<ScheduleResultPlayer> getSchedulePlayer() async {
    final idPlayer = preferencesDataSource.getIdPlayer();

    try {
      final schedules = await scheduleDataSource.getSchedulePlayer(idPlayer!);
      var listIdTeams = schedules.idTeams.split(",");
      preferencesDataSource.saveTeamsIds(
          listIdTeams.map((string) => int.parse(string)).toList());

      return schedules;
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<String> addSchedule(Event event, DateTime date) {
    return scheduleDataSource.addSchedule(event, date);
  }

  Future<String> addPlayerAttendance(String idEvent, String idPlayers) {
    return scheduleDataSource.addPlayerAttendance(idEvent, idPlayers);
  }
}
