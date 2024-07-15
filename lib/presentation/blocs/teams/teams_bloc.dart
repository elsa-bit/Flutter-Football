import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/domain/repositories/match_repository.dart';
import 'package:flutter_football/domain/repositories/team_repository.dart';
import 'package:flutter_football/presentation/blocs/teams/teams_event.dart';
import 'package:flutter_football/presentation/blocs/teams/teams_state.dart';

class TeamsBloc extends Bloc<TeamsEvent, TeamState> {
  final TeamRepository repository;
  final MatchRepository matchRepository;

  TeamsBloc({required this.repository, required this.matchRepository}) : super(TeamState()) {
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

    on<GetTeamMatchHistory>((event, emit) async {
      try {
        emit(state.copyWith(status: TeamStatus.historyLoading, teamMatches: [], wins: 0, nuls: 0, loses: 0));
        final matchList = await matchRepository.getTeamMatchDetails(event.teamId);
        final matchEnded = matchList.where((match) => match.win != null).toList();
        emit(state.copyWith(
          teamMatches: matchEnded,
          status: TeamStatus.success,
          wins: matchEnded.where((m) => m.win == "win").length,
          loses: matchEnded.where((m) => m.win == "lose").length,
          nuls: matchEnded.where((m) => m.win == "nul").length,
        ));
      } catch (error) {
        final errorMessage = error.toString().replaceFirst('Exception: ', '');
        emit(state.copyWith(error: errorMessage, status: TeamStatus.error));
      }
    });

    on<GetTeamPlayers>((event, emit) async {
      try {
        emit(state.copyWith(status: TeamStatus.loading));
        final players = await repository.getPlayers(event.teamId);
      } catch (error) {
        final errorMessage = error.toString().replaceFirst('Exception: ', '');
        emit(state.copyWith(error: errorMessage, status: TeamStatus.error));
      }
    });

    on<GetSpecificTeamPlayer>((event, emit) async {
      try {
        emit(state.copyWith(status: TeamStatus.loading));
        final teams = await repository.getSpecificTeamPlayer();
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
