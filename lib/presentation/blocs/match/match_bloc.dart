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
        emit(state.copyWith(
          error: (error is MatchError) ? error : MatchError(error.toString().replaceFirst('Exception: ', '')),
          status: MatchStatus.error,
        ));
      }
    });

    on<GetSelection>((event, emit) async {
      try {
        emit(state.copyWith(status: MatchStatus.loading));
        final selection = await repository.getSelection(event.idMatch, event.idTeam);
        emit(state.copyWith(status: MatchStatus.success, playerSelection: selection));
      } catch (error) {
        emit(state.copyWith(
          error: (error is MatchError) ? error : MatchError(error.toString().replaceFirst('Exception: ', '')),
          status: MatchStatus.error,
        ));
      }
    });

    on<SetFMIReport>((event, emit) async {
      try {
        emit(state.copyWith(status: MatchStatus.loading));
        final isFmiCreated = await repository.setFmiReport(event.idMatch, event.commentTeam, event.commentOpponent);
        if(isFmiCreated) emit(state.copyWith(status: MatchStatus.refresh));
        else emit(state.copyWith(status: MatchStatus.error, error: FMICreationError("Une erreur est survenue lors de la création de la FMI.")));
      } catch (error) {
        emit(state.copyWith(
          error: (error is MatchError) ? error : MatchError(error.toString().replaceFirst('Exception: ', '')) ,
          status: MatchStatus.error,
        ));
      }
    });

    on<SetSelection>((event, emit) async {
      try {
        emit(state.copyWith(status: MatchStatus.loading));
        await repository.setSelection(event.match.id, event.match.idTeam, event.idPlayers);
        emit(state.copyWith(status: MatchStatus.redirect, redirection: event.match));
      } catch (error) {
        emit(state.copyWith(
          error: (error is MatchError) ? error : MatchError(error.toString().replaceFirst('Exception: ', '')) ,
          status: MatchStatus.error,
        ));
      }
    });

    on<OnRedirectionDone>((event, emit) async {
      emit(state.copyWith(redirection: null));
    });
  }
}
