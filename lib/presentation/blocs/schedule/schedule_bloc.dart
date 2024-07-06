import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/domain/repositories/schedule_repository.dart';
import 'package:flutter_football/presentation/blocs/schedule/schedule_event.dart';
import 'package:flutter_football/presentation/blocs/schedule/schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final ScheduleRepository repository;

  ScheduleBloc({required this.repository}) : super(ScheduleState()) {
    on<GetSchedules>((event, emit) async {
      try {
        emit(state.copyWith(status: ScheduleStatus.loading));
        final schedule = await repository.getSchedule();
        emit(state.copyWith(
            matchs: schedule.matchs,
            trainings: schedule.trainings,
            meetings: schedule.meetings,
            status: ScheduleStatus.success));
      } catch (error) {
        final errorMessage = error.toString().replaceFirst('Exception: ', '');
        emit(state.copyWith(error: errorMessage, status: ScheduleStatus.getError));
      }
    });

    on<GetSchedulesPlayer>((event, emit) async {
      try {
        emit(state.copyWith(status: ScheduleStatus.loading));
        final schedule = await repository.getSchedulePlayer();
        emit(state.copyWith(
            matchs: schedule.matchs,
            trainings: schedule.trainings,
            status: ScheduleStatus.success));
      } catch (error) {
        final errorMessage = error.toString().replaceFirst('Exception: ', '');
        emit(state.copyWith(error: errorMessage, status: ScheduleStatus.error));
      }
    });

    on<AddSchedule>((event, emit) async {
      emit(state.copyWith(status: ScheduleStatus.loading));
      try {
        await repository.addSchedule(event.event, event.date);
        emit(state.copyWith(status: ScheduleStatus.addSuccess));
      } catch (e) {
        final errorMessage = e.toString().replaceFirst('Exception: ', '');
        emit(state.copyWith(error: errorMessage, status: ScheduleStatus.error));
      }
    });

    on<AddPlayerAttendance>((event, emit) async {
      emit(state.copyWith(status: ScheduleStatus.loading));
      try {
        await repository.addPlayerAttendance(event.idEvent, event.idPlayers);
        emit(state.copyWith(status: ScheduleStatus.addSuccess));
      } catch (e) {
        final errorMessage = e.toString().replaceFirst('Exception: ', '');
        emit(state.copyWith(error: errorMessage, status: ScheduleStatus.error));
      }
    });

    on<ClearScheduleStates>((event, emit) async {
      emit(ScheduleState());
    });
  }
}
