import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/domain/models/fmi/match_action.dart';
import 'package:flutter_football/domain/repositories/match_repository.dart';
import 'package:flutter_football/presentation/blocs/match/fmi/fmi_event.dart';
import 'package:flutter_football/presentation/blocs/match/fmi/fmi_state.dart';

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

        final actions = await repository.getActions(event.match.id);
        print(actions);
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
        final response =
            await repository.addGoal(event.idMatch, event.idPlayer);
        if (response.statusCode == 200) {
          emit(state.copyWith(
              /*TODO : retrieve object in response and add it to success data*/));
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
        final response = await repository.addReplacement(
            event.idMatch, event.idPlayerOut, event.idPlayerIn, event.reason);
        if (response.statusCode == 200) {
          emit(state.copyWith(
              /*TODO : retrieve object in response and add it to success data*/));
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
