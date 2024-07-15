import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/domain/models/team.dart';
import 'package:flutter_football/presentation/blocs/teams/teams_bloc.dart';
import 'package:flutter_football/presentation/blocs/teams/teams_event.dart';
import 'package:flutter_football/presentation/blocs/teams/teams_state.dart';
import 'package:flutter_football/presentation/screens/coach/teams/team_details_screen.dart';
import 'package:flutter_football/presentation/screens/coach/teams/team_item.dart';

class TeamsScreen extends StatefulWidget {
  static const String routeName = '/teams';

  const TeamsScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const TeamsScreen(),
    );
  }

  @override
  State<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TeamsBloc>(context).add(GetTeams());
  }

  Future<void> _refresh() async {
    BlocProvider.of<TeamsBloc>(context).add(GetTeams());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text("Mes équipes",
                style: TextStyle(color: AppColors.white))),
        backgroundColor: currentAppColors.secondaryColor,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: BlocBuilder<TeamsBloc, TeamState>(
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
                if (state.teams!.isEmpty) {
                  return const Center(
                    child: Text("Aucune équipe ne vous a été attribuée."),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: ListView.builder(
                    itemCount: state.teams!.length,
                    itemBuilder: (context, index) {
                      final team = state.teams![index];
                      return TeamItem(
                        team: team,
                        onTap: () => _onTeamTap(context, team),
                      );
                    },
                  ),
                );
              default:
                return const Center(
                  child: Text("Aucune équipe ne vous a été attribuée."),
                );
            }
          },
        ),
      ),
    );
  }

  void _onTeamTap(BuildContext context, Team team) async {
    Navigator.push(context, TeamDetailsScreen.route(team));
  }
}
