import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/domain/repositories/schedule_repository.dart';
import 'package:flutter_football/domain/repositories/team_repository.dart';
import 'package:flutter_football/presentation/blocs/schedule/schedule_event.dart';
import 'package:flutter_football/presentation/blocs/schedule/schedule_state.dart';
import 'package:flutter_football/presentation/blocs/teams/teams_event.dart';
import 'package:flutter_football/presentation/blocs/teams/teams_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final ScheduleRepository repository;

  ScheduleBloc({required this.repository}) : super(ScheduleState()) {
    on<GetSchedules>((event, emit) async {
      try {
        emit(state.copyWith(status: ScheduleStatus.loading));
        final schedule =
            await repository.getSchedule(event.idteams);
        emit(state.copyWith(
            matchs: schedule.matchs,
            trainings: schedule.trainings,
            meetings: schedule.meetings,
            status: ScheduleStatus.success));
      } catch (error) {
        emit(state.copyWith(
          error: error.toString(),
          status: ScheduleStatus.error,
        ));
      }
    });

    on<AddSchedule>((event, emit) async {
      emit(state.copyWith(status: ScheduleStatus.loading));
      try {
        await repository.addSchedule(event.event, event.date);
        emit(state.copyWith(status: ScheduleStatus.addSuccess));
      } catch (e) {
        emit(state.copyWith(error: e.toString(), status: ScheduleStatus.error));
      }
    });
  }
}
