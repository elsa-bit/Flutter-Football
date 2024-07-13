import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/data/data_sources/player_data_source.dart';
import 'package:flutter_football/domain/models/player.dart';
import 'package:flutter_football/domain/models/team.dart';
import 'package:flutter_football/domain/repositories/player_repository.dart';
import 'package:flutter_football/presentation/blocs/players/players_bloc.dart';
import 'package:flutter_football/presentation/blocs/players/players_event.dart';
import 'package:flutter_football/presentation/blocs/players/players_state.dart';
import 'package:flutter_football/utils/extensions/string_extension.dart';

class PlayerProfileScreen extends StatelessWidget {
  static const String routeName = '/playerProfile';
  final Player player;

  const PlayerProfileScreen({super.key, required this.player});

  static Route route(Player player) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => PlayerProfileScreen(player: player,),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${player.firstname} ${player.lastname}"),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(70.0, 40.0, 70.0, 40.0),
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PlayerStatItem(name: "Matchs joués", value: player.matchPlayed.toString()),
            PlayerStatItem(name: "Position", value: (player.position?.isNotEmpty == true) ? player.position!.toString().capitalize() : "_"),
            PlayerStatItem(name: "Licence", value: player.num_licence?.toString() ?? "_"),
          ],
        ),
      ),
    );
  }

}

class PlayerStatItem extends StatelessWidget {
  final String name;
  final String value;

  const PlayerStatItem({super.key, required this.name, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name),
        Text(value),
      ],
    );
  }

}