import 'package:flutter/material.dart';

class RankingTeamScreen extends StatefulWidget {
  static const String routeName = '/player/rankingTeam';
  final String idPlayer;
  final String idTeams;

  const RankingTeamScreen({Key? key, required this.idPlayer, required this.idTeams}) : super(key: key);

  static void navigateTo(
      BuildContext context, String idPlayer, String idTeams) {
    Navigator.of(context).pushNamed(
      routeName,
      arguments: {'idPlayer': idPlayer, 'idTeams': idTeams},
    );
  }

  static Route route(RouteSettings settings) {
    final args = settings.arguments as Map<String, String>;
    final idPlayer = args['idPlayer']!;
    final idTeams = args['idTeams']!;
    return MaterialPageRoute(
      builder: (context) => RankingTeamScreen(idPlayer: idPlayer, idTeams: idTeams),
    );
  }

  @override
  State<RankingTeamScreen> createState() => _RankingTeamScreenState();
}

class _RankingTeamScreenState extends State<RankingTeamScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Equipes"),
    );
  }
}
