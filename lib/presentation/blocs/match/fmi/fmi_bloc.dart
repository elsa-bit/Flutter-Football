import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/domain/repositories/match_repository.dart';
import 'package:flutter_football/presentation/blocs/match/fmi/fmi_event.dart';
import 'package:flutter_football/presentation/blocs/match/fmi/fmi_state.dart';

class FmiBloc extends Bloc<FmiEvent, FmiState> {
  final MatchRepository repository;

  FmiBloc({required this.repository}) : super(FmiState()) {
    on<InitFMI>((event, emit) async {
      try {
        emit(state.copyWith(status: FmiStatus.loading));
        //final matches = await repository.getMatches();
        //matches.sort((a, b) => a.date.compareTo(b.date));
        //final i = matches.indexWhere((m) => m.date.isEqualOrAfter(DateTime.now()));
        emit(state.copyWith(
          status: FmiStatus.success,
        ));
      } catch (error) {
        emit(state.copyWith(
          error: error.toString(),
          status: FmiStatus.error,
        ));
      }
    });

    on<AddCard>((event, emit) async {
      try {
        emit(state.copyWith(status: FmiStatus.loading));
        final response = await repository.addCard(event.idMatch, event.idPlayer, event.color);
        if (response.statusCode == 200) {
          emit(state.copyWith(/*TODO : retrieve object in response and add it to success data*/));
        } else {
          emit(state.copyWith(/*error: FMIErrorType.Card */));
        }
      } catch (error) {
        emit(state.copyWith(
          error: error.toString(),
          status: FmiStatus.error,
        ));
      }
    });

    on<AddGoal>((event, emit) async {
      try {
        emit(state.copyWith(status: FmiStatus.loading));
        final response = await repository.addGoal(event.idMatch, event.idPlayer);
        if (response.statusCode == 200) {
          emit(state.copyWith(/*TODO : retrieve object in response and add it to success data*/));
        } else {
          emit(state.copyWith(/*error: FMIErrorType.Goal */));
        }
      } catch (error) {
        emit(state.copyWith(
          error: error.toString(),
          status: FmiStatus.error,
        ));
      }
    });

    on<AddReplacement>((event, emit) async {
      try {
        emit(state.copyWith(status: FmiStatus.loading));
        final response = await repository.addReplacement(event.idMatch, event.idPlayerOut, event.idPlayerIn, event.reason);
        if (response.statusCode == 200) {
          emit(state.copyWith(/*TODO : retrieve object in response and add it to success data*/));
        } else {
          emit(state.copyWith(/*error: FMIErrorType.Replacement */));
        }
      } catch (error) {
        emit(state.copyWith(
          error: error.toString(),
          status: FmiStatus.error,
        ));
      }
    });

  }
}
