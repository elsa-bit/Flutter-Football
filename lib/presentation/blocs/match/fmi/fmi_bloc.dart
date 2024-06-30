import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/domain/models/fmi/match_action.dart';
import 'package:flutter_football/domain/repositories/match_repository.dart';
import 'package:flutter_football/presentation/blocs/match/fmi/fmi_event.dart';
import 'package:flutter_football/presentation/blocs/match/fmi/fmi_state.dart';
import 'package:flutter_football/utils/extensions/date_time_extension.dart';

class FmiBloc extends Bloc<FmiEvent, FmiState> {
  final MatchRepository repository;

  FmiBloc({required this.repository}) : super(FmiState()) {
    on<InitFMI>((event, emit) async {
      try {
        emit(FmiState());
        // Init state with match data
        emit(state.copyWith(
          status: FmiStatus.success,
          match: event.match,
        ));

        final actions = await repository.getActions(event.match.id, event.match.date);
        emit(state.copyWith(
          status: FmiStatus.success,
          actions: actions,
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
        final card = await repository.addCard(
            event.idMatch, event.idPlayer, event.color);
        final cardAction = CardAction(
          id: "card-${card.id}",
          createdAt: card.createdAt,
          matchTime: card.createdAt.formatMatchTime(state.match!.date),
          assetName: (card.color == "yellow")
              ? "assets/yellow_card.svg"
              : "assets/red_card.svg",
          card: card,
        );
        emit(state.copyWith(action: cardAction));
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
        emit(state.copyWith(action: replacementAction));
      } catch (error) {
        emit(state.copyWith(
          error: error.toString(),
          status: FmiStatus.error,
        ));
      }
    });
  }


}
