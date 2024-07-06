import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/domain/repositories/team_repository.dart';
import 'package:flutter_football/presentation/blocs/teams/teams_event.dart';
import 'package:flutter_football/presentation/blocs/teams/teams_state.dart';

class TeamsBloc extends Bloc<TeamsEvent, TeamState> {
  final TeamRepository repository;

  TeamsBloc({required this.repository}) : super(TeamState()) {
    on<GetTeamDetails>((event, emit) async {
      try {
        emit(state.copyWith(status: TeamStatus.loading));
        final team = await repository.getTeam(event.teamId);
        emit(state.copyWith(teamDetail: team, status: TeamStatus.success));
      } catch (error) {
        final errorMessage = error.toString().replaceFirst('Exception: ', '');
        emit(state.copyWith(error: errorMessage, status: TeamStatus.error));
      }
    });

    on<GetTeams>((event, emit) async {
      try {
        emit(state.copyWith(status: TeamStatus.loading));
        final teams = await repository.getCoachTeams();
        emit(state.copyWith(teams: teams, status: TeamStatus.success));
      } catch (error) {
        final errorMessage = error.toString().replaceFirst('Exception: ', '');
        emit(state.copyWith(error: errorMessage, status: TeamStatus.error));
      }
    });

    on<GetTeamPlayers>((event, emit) async {
      try {
        emit(state.copyWith(status: TeamStatus.loading));
        final players = await repository.getPlayers(event.teamId);
        //emit(state.copyWith(teams: teams, status: TeamStatus.success));
      } catch (error) {
        final errorMessage = error.toString().replaceFirst('Exception: ', '');
        emit(state.copyWith(error: errorMessage, status: TeamStatus.error));
      }
    });

    on<GetSpecificTeamPlayer>((event, emit) async {
      try {
        emit(state.copyWith(status: TeamStatus.loading));
        final teams = await repository.getSpecificTeamPlayer(event.idPlayer);
        emit(state.copyWith(teams: teams, status: TeamStatus.success));
      } catch (error) {
        final errorMessage = error.toString().replaceFirst('Exception: ', '');
        emit(state.copyWith(error: errorMessage, status: TeamStatus.error));
      }
    });

    on<ClearTeamsState>((event, emit) async {
      emit(TeamState());
    });
  }
}
