import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/data/data_sources/player_data_source.dart';
import 'package:flutter_football/data/data_sources/shared_preferences_data_source.dart';
import 'package:flutter_football/domain/models/player.dart';
import 'package:flutter_football/domain/models/team.dart';
import 'package:flutter_football/domain/repositories/player_repository.dart';
import 'package:flutter_football/presentation/blocs/players/players_bloc.dart';
import 'package:flutter_football/presentation/blocs/players/players_event.dart';
import 'package:flutter_football/presentation/blocs/players/players_state.dart';
import 'package:flutter_football/presentation/screens/coach/teams/player_item.dart';
import 'package:flutter_football/presentation/screens/coach/teams/player_profile_screen.dart';

class TeamPlayersScreen extends StatelessWidget {
  static const String routeName = '/teamPlayers';
  final Team team;

  const TeamPlayersScreen({super.key, required this.team});

  static Route route(Team team) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => TeamPlayersScreen(
        team: team,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) =>
          PlayerRepository(
              playerDataSource: PlayerDataSource(),
              preferencesDataSource: SharedPreferencesDataSource(),
          ),
      child: BlocProvider(
        create: (context) => PlayersBloc(
          repository: RepositoryProvider.of<PlayerRepository>(context),
        )..add(GetPlayersTeam(teamId: "${team.id}")),
        child: Scaffold(
          appBar: AppBar(
            title: Text(team.name),
            backgroundColor: currentAppColors.secondaryColor,
          ),
          body: BlocBuilder<PlayersBloc, PlayersState>(
            builder: (context, state) {
              switch (state.status) {
                case PlayersStatus.loading:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case PlayersStatus.error:
                  return Center(
                    child: Text(
                      state.error,
                    ),
                  );
                case PlayersStatus.success:
                  if (state.players!.isEmpty) {
                    return const Center(
                      child: Text("Aucun joueur dans cette équipe."),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.players?.length ?? 0,
                    itemBuilder: (context, index) {
                      final player = state.players![index];
                      return PlayerItem(
                        player: player,
                        onTap: () => _onPlayerTap(context, player),
                      );
                    },
                  );
                default:
                  return const Center(
                    child: Text("Aucun joueur dans cette équipe."),
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  void _onPlayerTap(BuildContext context, Player player) async {
    Navigator.push(context, PlayerProfileScreen.route(player));
  }
}
