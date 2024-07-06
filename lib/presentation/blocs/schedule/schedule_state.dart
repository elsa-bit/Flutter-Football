import 'package:flutter_football/domain/models/match.dart';
import 'package:flutter_football/domain/models/meeting.dart';
import 'package:flutter_football/domain/models/training.dart';

enum ScheduleStatus { initial, loading, success, addSuccess, error, getError }

class ScheduleState {
  final ScheduleStatus status;
  final List<Match>? matchs;
  final List<Training>? trainings;
  final List<Meeting>? meetings;
  final String? idTeams;
  final String error;

  ScheduleState({
    this.status = ScheduleStatus.initial,
    this.matchs = const [],
    this.trainings = const [],
    this.meetings = const [],
    this.idTeams = '',
    this.error = '',
  });

  ScheduleState copyWith({
    ScheduleStatus? status,
    final List<Match>? matchs,
    final List<Training>? trainings,
    final List<Meeting>? meetings,
    final String? idTeams,
    String? error,
  }) {
    return ScheduleState(
        status: status ?? this.status,
        matchs: matchs ?? this.matchs,
        trainings: trainings ?? this.trainings,
        meetings: meetings ?? this.meetings,
        idTeams: idTeams ?? this.idTeams,
        error: error ?? this.error);
  }
}
