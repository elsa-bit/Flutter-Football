import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/domain/models/fmi/match_action.dart';
import 'package:flutter_football/domain/models/match_details.dart';
import 'package:flutter_football/domain/models/player.dart';
import 'package:flutter_football/domain/repositories/match_repository.dart';
import 'package:flutter_football/domain/repositories/player_repository.dart';
import 'package:flutter_football/presentation/blocs/match/fmi/fmi_event.dart';
import 'package:flutter_football/presentation/blocs/match/fmi/fmi_state.dart';
import 'package:flutter_football/utils/extensions/date_time_extension.dart';

class FmiBloc extends Bloc<FmiEvent, FmiState> {
  final MatchRepository repository;
  final PlayerRepository playerRepository;

  FmiBloc({required this.repository, required this.playerRepository}) : super(FmiState()) {

    Future<List<MatchAction>?> initFMIWithActions(MatchDetails match, Emitter<FmiState> emit) async {
      try {
        final actions = await repository.getActions(match.id, match.date);
        emit(state.copyWith(
          status: FmiStatus.success,
          actions: actions,
        ));
        return actions;
      } catch (error) {
        emit(state.copyWith(
          error: error.toString(),
          status: FmiStatus.error,
        ));
        return null;
      }
    }

    Future<void> setPlayers(MatchDetails match, List<MatchAction>? matchActions, Emitter<FmiState> emit) async {
      try {
        emit(state.copyWith(status: FmiStatus.loadingPlayer));
        final players = await playerRepository.getPlayersTeam(match.idTeam);

        List<Player> inMatch = players;
        List<Player> forReplacement = players;

        if(match.playerSelection != null && match.playerSelection!.isNotEmpty) {
          inMatch = players.where((p) => match.playerSelection!.contains(p.id)).toList();
          forReplacement = players.where((p) => !match.playerSelection!.contains(p.id)).toList();
        }

        if(matchActions != null && matchActions.isNotEmpty) {
          // update players list based on the actions
          for (final action in matchActions) {
            if(action is ReplacementAction) {
              final indexOut = inMatch.indexWhere((player) => player.id == action.replacement.playerOut.id);
              if (indexOut != -1) {
                final playerRemoved = inMatch.removeAt(indexOut);
                forReplacement.add(playerRemoved);
              }

              final indexIn = forReplacement.indexWhere((player) => player.id == action.replacement.playerIn.id);
              if (indexIn != -1) {
                final playerRemoved = forReplacement.removeAt(indexIn);
                inMatch.add(playerRemoved);
              }
            } else if (action is CardAction && action.card.color == "red") {
              inMatch.removeWhere((player) => player.id == action.card.player.id);
            }
          }
        }
        emit(state.copyWith(
            playersInGame: inMatch,
            playerSearch: inMatch,
            playersInReplacement: forReplacement,
            status: FmiStatus.success));
      } catch (error) {
        final errorMessage = error.toString().replaceFirst('Exception: ', '');
        emit(state.copyWith(error: errorMessage, status: FmiStatus.error));
      }
    }


    on<InitFMI>((event, emit) async {
      emit(FmiState());
      emit(state.copyWith(
        status: FmiStatus.success,
        match: event.match,
      ));

      final actions = await initFMIWithActions(event.match, emit);
      await setPlayers(event.match, actions, emit);
    });

    on<AddCard>((event, emit) async {
      try {
        emit(state.copyWith(status: FmiStatus.loading));
        final bool alreadyHaveYellowCard = (event.color == "red") ? true : (state.actions?.where((action) {
          return (action is CardAction && action.card.player.id == event.idPlayer);
        }).isNotEmpty ?? false);

        final card = await repository.addCard(
            event.idMatch, event.idPlayer, alreadyHaveYellowCard ? "red" : event.color);
        final cardAction = CardAction(
          id: "card-${card.id}",
          createdAt: card.createdAt,
          matchTime: card.createdAt.formatMatchTime(state.match!.date),
          assetName: (card.color == "yellow")
              ? "assets/yellow_card.svg"
              : "assets/red_card.svg",
          card: card,
        );

        // Update list of players in match
        if (card.color == "red") {
          List<Player>? newList = state.playersInGame;
          newList?.removeWhere((player) => player.id == card.player.id);
          emit(state.copyWith(action: cardAction, playersInGame: newList));
        } else {
          emit(state.copyWith(action: cardAction));
        }
      } catch (error) {
        // TODO : replace error field with custom error Type
        // TODO : catch error if card can't be created FMICardCreationException

        emit(state.copyWith(
          error: error.toString(),
          status: FmiStatus.error,
        ));
      }
    });

    on<AddGoal>((event, emit) async {
      try {
        emit(state.copyWith(status: FmiStatus.loading));
        final goal = await repository.addGoal(event.idMatch, event.idPlayer);
        final goalAction = GoalAction(
          id: "goal-${goal.id}",
          createdAt: goal.createdAt,
          matchTime: goal.createdAt.formatMatchTime(state.match!.date),
          assetName: "assets/football_icon.svg",
          assetTint: goal.fromOpponent ? AppColors.red : AppColors.green,
          goal: goal,
        );
        emit(state.copyWith(
          action: goalAction,
          match: state.match?.copyWith(
            teamGoals: !goal.fromOpponent ? ((state.match?.teamGoals ?? 0) + 1) : null,
            opponentGoals: goal.fromOpponent ? ((state.match?.opponentGoals ?? 0) + 1) : null,
          ),
        ));
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
        final replacement = await repository.addReplacement(
            event.idMatch, event.idPlayerOut, event.idPlayerIn, event.reason);
        final replacementAction = ReplacementAction(
          id: "replacement-${replacement.id}",
          createdAt: replacement.createdAt,
          matchTime: replacement.createdAt.formatMatchTime(state.match!.date),
          assetName: "assets/replacement_icon.svg",
          replacement: replacement,
          assetTint: AppColors.mediumBlue,
        );

        // update players state
        List<Player>? newPlayersInGame = state.playersInGame;
        List<Player>? newPlayersInReplacement = state.playersInReplacement;
        final indexOut = newPlayersInGame?.indexWhere((player) => player.id == replacement.playerOut.id) ?? -1;
        if (indexOut != -1) {
          final playerRemoved = newPlayersInGame!.removeAt(indexOut);
          newPlayersInReplacement?.add(playerRemoved);
        }

        final indexIn = newPlayersInReplacement?.indexWhere((player) => player.id == replacement.playerIn.id) ?? -1;
        if (indexIn != -1) {
          final playerRemoved = newPlayersInReplacement!.removeAt(indexIn);
          newPlayersInGame?.add(playerRemoved);
        }
        emit(state.copyWith(action: replacementAction, playersInGame: newPlayersInGame, playerSearch: newPlayersInGame, playersInReplacement: newPlayersInReplacement));
      } catch (error) {
        emit(state.copyWith(
          error: error.toString(),
          status: FmiStatus.error,
        ));
      }
    });

    on<Search>((event, emit) async {
      try {
        emit(state.copyWith(playerSearch: []));

        await Future.delayed(const Duration(milliseconds: 300), () {
          final searchList;
          if (event.search.isEmpty) {
            searchList = state.playersInGame;
          } else {
            searchList = state.playersInGame
                ?.where((p) => p.isMatching(event.search))
                .toList();
          }

          emit(state.copyWith(playerSearch: searchList));
        });
      } catch (e) {
        emit(state.copyWith(playerSearch: state.playersInGame));
        //emit(state.copyWith(error: e.toString(), status: FmiStatus.error));
      }
    });

    on<ClearFMIState>((event, emit) async {
     emit(FmiState());
    });



  }


}
