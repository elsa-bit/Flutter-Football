import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_football/data/data_sources/shared_preferences_data_source.dart';
import 'package:flutter_football/domain/models/player.dart';
import 'package:flutter_football/domain/repositories/player_repository.dart';
import 'package:flutter_football/presentation/blocs/players/players_event.dart';
import 'package:flutter_football/presentation/blocs/players/players_state.dart';

class PlayersBloc extends Bloc<PlayersEvent, PlayersState> {
  final PlayerRepository repository;
  StreamSubscription<Player>? _subscription;
  SharedPreferencesDataSource preferences = SharedPreferencesDataSource();

  PlayersBloc({required this.repository}) : super(PlayersState()) {
    on<GetPlayersTeam>((event, emit) async {
      try {
        emit(state.copyWith(status: PlayersStatus.loading));
        final players = await repository.getPlayersTeam(event.teamId);
        emit(state.copyWith(
            players: players,
            playerSearch: players,
            status: PlayersStatus.success));
      } catch (error) {
        final errorMessage = error.toString().replaceFirst('Exception: ', '');
        emit(state.copyWith(error: errorMessage, status: PlayersStatus.error));
      }
    });

    on<GetPlayersTeams>((event, emit) async {
      try {
        emit(state.copyWith(status: PlayersStatus.loading));
        final players = await repository.getPlayersTeams();
        emit(state.copyWith(
            players: players,
            playerSearch: players,
            status: PlayersStatus.success));
      } catch (error) {
        final errorMessage = error.toString().replaceFirst('Exception: ', '');
        emit(state.copyWith(error: errorMessage, status: PlayersStatus.error));
      }
    });

    on<GetPlayerDetails>((event, emit) async {
      try {
        emit(state.copyWith(status: PlayersStatus.loading));
        final detailsPlayer = await repository.getPlayerDetails();
        emit(state.copyWith(
            detailsPlayer: detailsPlayer, status: PlayersStatus.success));
      } catch (error) {
        final errorMessage = error.toString().replaceFirst('Exception: ', '');
        emit(state.copyWith(error: errorMessage, status: PlayersStatus.error));
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
            searchList = state.players
                ?.where((p) => p.isMatching(event.search))
                .toList();
          }

          emit(state.copyWith(playerSearch: searchList));
        });
      } catch (e) {
        emit(state.copyWith(playerSearch: state.players));
        //emit(state.copyWith(error: e.toString(), status: FmiStatus.error));
      }
    });

    on<AddFriend>((event, emit) async {
      emit(state.copyWith(status: PlayersStatus.loading));
      try {
        await repository.addFriend(event.idPlayer, event.idFriend);
        emit(state.copyWith(status: PlayersStatus.success));
      } catch (e) {
        final errorMessage = e.toString().replaceFirst('Exception: ', '');
        debugPrint("ICIIIIIIIIIII");
        emit(state.copyWith(error: errorMessage, status: PlayersStatus.addFriendError));
      }
    });

    on<GetFriendsPlayer>((event, emit) async {
      try {
        emit(state.copyWith(status: PlayersStatus.loading));
        final players = await repository.getFriendsPlayer(event.idPlayer);
        emit(state.copyWith(players: players, status: PlayersStatus.success));
      } catch (error) {
        final errorMessage = error.toString().replaceFirst('Exception: ', '');
        emit(state.copyWith(error: errorMessage, status: PlayersStatus.error));
      }
    });

    on<ModifyPlayer>((event, emit) async {
      emit(state.copyWith(status: PlayersStatus.loading));
      try {
        await repository.modifyPlayer(event.player);
        emit(state.copyWith(status: PlayersStatus.modifySuccess));
      } catch (e) {
        final errorMessage = e.toString().replaceFirst('Exception: ', '');
        emit(state.copyWith(error: errorMessage, status: PlayersStatus.error));
      }
    });

    on<GetCoachPlayer>((event, emit) async {
      try {
        emit(state.copyWith(status: PlayersStatus.loading));
        final coachs = await repository.getCoachPlayer();
        emit(state.copyWith(coachs: coachs, status: PlayersStatus.success));
      } catch (error) {
        final errorMessage = error.toString().replaceFirst('Exception: ', '');
        emit(state.copyWith(error: errorMessage, status: PlayersStatus.error));
      }
    });

    on<SubscribeToPlayer>((event, emit) async {
      try {
        await _subscription?.cancel();
        await for (final player in repository.subscribeToPlayer()) {
          var idPlayer = preferences.getIdPlayer();
          if (player.id == idPlayer) {
            emit(state.copyWith(
                detailsPlayer: player, status: PlayersStatus.success));
          }
        }
      } catch (e) {
        final errorMessage = e.toString().replaceFirst('Exception: ', '');
        emit(state.copyWith(error: errorMessage, status: PlayersStatus.error));
      }
    });

    on<GetNewTrophy>((event, emit) async {
      try {
        emit(state.copyWith(status: PlayersStatus.loading));
        final detailsPlayer = await repository.getNewTrophy(event.oldDate);
        emit(state.copyWith(
            detailsPlayer: detailsPlayer, status: PlayersStatus.success));
      } catch (error) {
        final errorMessage = error.toString().replaceFirst('Exception: ', '');
        emit(state.copyWith(error: errorMessage, status: PlayersStatus.error));
      }
    });

    on<ClearPlayerState>((event, emit) async {
      emit(PlayersState());
    });
  }
}
