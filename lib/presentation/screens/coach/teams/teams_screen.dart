import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/data/data_sources/shared_preferences_data_source.dart';
import 'package:flutter_football/data/data_sources/team_data_source.dart';
import 'package:flutter_football/domain/models/team.dart';
import 'package:flutter_football/domain/repositories/team_repository.dart';
import 'package:flutter_football/presentation/blocs/teams/teams_bloc.dart';
import 'package:flutter_football/presentation/blocs/teams/teams_event.dart';
import 'package:flutter_football/presentation/blocs/teams/teams_state.dart';
import 'package:flutter_football/presentation/screens/coach/teams/team_item.dart';
import 'package:flutter_football/presentation/screens/coach/teams/team_players_screen.dart';

class TeamsScreen extends StatelessWidget {
  static const String routeName = '/teams';

  const TeamsScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const TeamsScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => TeamRepository(
          teamDataSource: TeamDataSource(),
          preferences: SharedPreferencesDataSource(),
      ),
      child: BlocProvider(
        create: (context) => TeamsBloc(
          repository: RepositoryProvider.of<TeamRepository>(context),
        )
        ..add(GetTeams()),
        child: Scaffold(
          appBar: AppBar(
            title: Center(child: Text("Mes équipes")),
            backgroundColor: currentAppColors.secondaryColor,
          ),
          body: BlocBuilder<TeamsBloc, TeamState>(
            builder: (context, state) {
              switch (state.status) {
                case TeamStatus.loading:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case TeamStatus.error:
                  return Center(
                    child: Text(
                      state.error,
                    ),
                  );
                case TeamStatus.success:
                  if (state.teams.isEmpty) {
                    return const Center(
                      child: Text("Aucune équipe ne vous a été attribuée."),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.teams.length,
                    itemBuilder: (context, index) {
                      final team = state.teams[index];
                      return TeamItem(
                          team: team,
                        onTap: () => _onTeamTap(context, team),
                      );
                    },
                  );
                default:
                  return const Center(
                    child: Text("Aucune équipe ne vous a été attribuée."),
                  );
              }
            },
          ),
          /*Padding(
              padding: const EdgeInsets.fromLTRB(70.0, 40.0, 70.0, 0.0),
              child: Column(
                children: [
                  TeamItem(team: Team(id: 1,
                      name: "U13",
                      coachIds: [],
                      playerAccessEnabled: false)),
                ],
              ),
            )*/
        ),
      ),
    );
  }

  void _onTeamTap(BuildContext context, Team team) async {
    Navigator.push(
      context,
      TeamPlayersScreen.route(team)
    );
  }
}
