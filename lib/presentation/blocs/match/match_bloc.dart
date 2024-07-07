import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/domain/models/match_details.dart';
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
        int i =
            matches.indexWhere((m) => m.date.isEqualOrAfter(DateTime.now()));
        List<MatchDetails> previousMatch =
            (i < 0) ? matches : matches.sublist(0, i);
        List<MatchDetails> nextMatch =
            (i < 0) ? [] : matches.sublist(i, matches.length);

        emit(state.copyWith(
          status: MatchStatus.success,
          previousMatch: previousMatch,
          nextMatch: nextMatch,
        ));
      } catch (error) {
        final errorMessage = error.toString().replaceFirst('Exception: ', '');
        emit(state.copyWith(error: errorMessage, status: MatchStatus.error));
      }
    });
  }
}
