
import 'package:flutter_football/domain/models/event.dart';

abstract class ScheduleEvent {}

class GetSchedules extends ScheduleEvent {
  final String idteams;

  GetSchedules({
    required this.idteams
  });
}

class AddSchedule extends ScheduleEvent {
  final Event event;
  final DateTime date;

  AddSchedule({
    required this.event,
    required this.date,
  });
}