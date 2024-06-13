import 'dart:convert';

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

  Future<ScheduleResult> getSchedule(String idteams) async {
    final idCoach = preferencesDataSource.getIdCoach();

    try {
      final schedules = await scheduleDataSource.getSchedule(idCoach!, idteams);
      return schedules;
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<String> addSchedule(Event event, DateTime date) {
    return scheduleDataSource.addSchedule(event, date);
  }
}
