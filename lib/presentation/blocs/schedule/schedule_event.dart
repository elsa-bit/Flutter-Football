
import 'package:flutter_football/domain/models/event.dart';

abstract class ScheduleEvent {}

class GetSchedules extends ScheduleEvent {
  GetSchedules();
}

class AddSchedule extends ScheduleEvent {
  final Event event;
  final DateTime date;

  AddSchedule({
    required this.event,
    required this.date,
  });
}

class AddPlayerAttendance extends ScheduleEvent {
  final String idEvent;
  final String idPlayers;

  AddPlayerAttendance({
    required this.idEvent,
    required this.idPlayers,
  });
}