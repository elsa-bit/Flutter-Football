import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/domain/repositories/coach_repository.dart';
import 'package:flutter_football/presentation/blocs/coach/coach_event.dart';
import 'package:flutter_football/presentation/blocs/coach/coach_state.dart';

class CoachBloc extends Bloc<CoachEvent, CoachState> {
  final CoachRepository repository;

  CoachBloc({required this.repository}) : super(CoachState()) {
    on<GetCoachDetails>((event, emit) async {
      try {
        emit(state.copyWith(status: CoachStatus.loading));
        final detailsCoach = await repository.getCoachDetails();
        emit(state.copyWith(
            detailsCoach: detailsCoach, status: CoachStatus.success));
      } catch (error) {
        final errorMessage = error.toString().replaceFirst('Exception: ', '');
        emit(state.copyWith(error: errorMessage, status: CoachStatus.error));
      }
    });
  }
}
