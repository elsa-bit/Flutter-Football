import 'package:flutter_football/domain/models/match.dart';
import 'package:flutter_football/domain/models/meeting.dart';
import 'package:flutter_football/domain/models/training.dart';

enum ScheduleStatus { initial, loading, success, addSuccess, error }

class ScheduleState {
  final ScheduleStatus status;
  final List<Match>? matchs;
  final List<Training>? trainings;
  final List<Meeting>? meetings;
  final String error;

  ScheduleState({
    this.status = ScheduleStatus.initial,
    this.matchs = const [],
    this.trainings = const [],
    this.meetings = const [],
    this.error = '',
  });

  ScheduleState copyWith({
    ScheduleStatus? status,
    final List<Match>? matchs,
    final List<Training>? trainings,
    final List<Meeting>? meetings,
    String? error,
  }) {
    return ScheduleState(
        status: status ?? this.status,
        matchs: matchs ?? this.matchs,
        trainings: trainings ?? this.trainings,
        meetings: meetings ?? this.meetings,
        error: error ?? this.error);
  }
}
