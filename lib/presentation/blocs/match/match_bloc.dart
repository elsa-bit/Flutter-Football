import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/domain/repositories/match_repository.dart';
import 'package:flutter_football/presentation/blocs/match/match_event.dart';
import 'package:flutter_football/presentation/blocs/match/match_state.dart';
import 'package:flutter_football/utils/extensions/date_time_extension.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  final MatchRepository repository;

  MatchBloc({required this.repository}) : super(MatchState()) {
    on<GetMatches>((event, emit) async {
      try {
        emit(state.copyWith(status: MatchStatus.loading));
        final matches = await repository.getMatchesDetails();
        matches.sort((a, b) => a.date.compareTo(b.date));
        int i = matches.indexWhere((m) => m.date.isEqualOrAfter(DateTime.now()));
        if(i < 0) i = 0;

        emit(state.copyWith(
          status: MatchStatus.success,
          previousMatch: matches.sublist(0, i),
          nextMatch: matches.sublist(i, matches.length),
        ));
      } catch (error) {
        emit(state.copyWith(
          error: error.toString(),
          status: MatchStatus.error,
        ));
      }
    });
  }
}
