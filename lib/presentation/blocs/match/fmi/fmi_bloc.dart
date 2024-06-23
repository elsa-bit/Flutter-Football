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
  }
}
