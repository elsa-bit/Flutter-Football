import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/domain/models/player.dart';
import 'package:flutter_football/presentation/blocs/players/players_bloc.dart';
import 'package:flutter_football/presentation/blocs/players/players_state.dart';
import 'package:flutter_football/presentation/screens/coach/teams/player_item.dart';
import 'package:flutter_football/presentation/screens/coach/teams/player_profile_screen.dart';

class TeamPlayersScreen extends StatelessWidget {
  static const String routeName = 'team-players';

  const TeamPlayersScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => TeamPlayersScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayersBloc, PlayersState>(
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
            return Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: ListView.builder(
                itemCount: state.players?.length ?? 0,
                itemBuilder: (context, index) {
                  final player = state.players![index];
                  return PlayerItem(
                    player: player,
                    onTap: () => _onPlayerTap(context, player),
                  );
                },
              ),
            );
          default:
            return const Center(
              child: Text("Aucun joueur dans cette équipe."),
            );
        }
      },
    );
  }

  void _onPlayerTap(BuildContext context, Player player) async {
    Navigator.push(context, PlayerProfileScreen.route(player));
  }
}
