import 'package:bloc/bloc.dart';
import 'package:flutter_football/domain/repositories/player_repository.dart';
import 'package:flutter_football/presentation/blocs/players/players_event.dart';
import 'package:flutter_football/presentation/blocs/players/players_state.dart';

class PlayersBloc extends Bloc<PlayersEvent, PlayersState> {
  final PlayerRepository repository;

  PlayersBloc({required this.repository}) : super(PlayersState()) {
    on<GetPlayersTeam>((event, emit) async {
      try {
        emit(state.copyWith(status: PlayersStatus.loading));
        final players = await repository.getPlayersTeams(event.teamId);
        emit(state.copyWith(players: players, playerSearch: players, status: PlayersStatus.success));
      } catch (error) {
        emit(state.copyWith(
          error: error.toString(),
          status: PlayersStatus.error,
        ));
      }
    });

    on<GetPlayerDetails>((event, emit) async {
      try {
        emit(state.copyWith(status: PlayersStatus.loading));
        final detailsPlayer = await repository.getPlayerDetails();
        emit(state.copyWith(detailsPlayer: detailsPlayer, status: PlayersStatus.success));
      } catch (error) {
        emit(state.copyWith(
          error: error.toString(),
          status: PlayersStatus.error,
        ));
      }
    });

    on<AddFriend>((event, emit) async {
      emit(state.copyWith(status: PlayersStatus.loading));
      try {
        await repository.addFriend(event.idPlayer, event.idFriend);
        emit(state.copyWith(status: PlayersStatus.success));
      } catch (e) {
        emit(state.copyWith(error: e.toString(), status: PlayersStatus.error));
      }
    });

    on<GetFriendsPlayer>((event, emit) async {
      try {
        emit(state.copyWith(status: PlayersStatus.loading));
        final players = await repository.getFriendsPlayer(event.idPlayer);
        emit(state.copyWith(players: players, status: PlayersStatus.success));
      } catch (error) {
        emit(state.copyWith(
          error: error.toString(),
          status: PlayersStatus.error,
        ));
      }
    });

    on<Search>((event, emit) async {
      try {
        emit(state.copyWith(playerSearch: []));

        await Future.delayed(const Duration(milliseconds: 300), () {
          final searchList;
          if (event.search.isEmpty) {
            searchList = state.players;
          } else {
            searchList = state.players?.where((p) => p.isMatching(event.search)).toList();
          }

          emit(state.copyWith(playerSearch: searchList));
        });

        final searchList;
        if (event.search.isEmpty) {
          searchList = state.players;
        } else {
          searchList = state.players?.where((p) => p.isMatching(event.search)).toList();
        }

        emit(state.copyWith(playerSearch: searchList));

      } catch (e) {
        emit(state.copyWith(error: e.toString(), status: PlayersStatus.error));
      }
    });
  }



}
