import 'package:flutter/material.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/domain/models/team.dart';

class TeamPlayersScreen extends StatelessWidget {
  static const String routeName = '/teamPlayers';
  final Team team;

  const TeamPlayersScreen({super.key, required this.team});

  static Route route(Team team) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => TeamPlayersScreen(team: team,),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Joueurs"),
        backgroundColor: currentAppColors.secondaryColor,
      ),
      body: Center(
        child: Column(
          children: [
            Text(team.name),
          ],
        ),
      ),
    );
  }

}