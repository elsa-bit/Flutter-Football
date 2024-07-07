import 'package:flutter/material.dart' hide Card;
import 'package:flutter_football/domain/models/match_details.dart';

class SelectionScreen extends StatelessWidget {
  static const String routeName = '/selection';
  final MatchDetails match;

  static Route route(MatchDetails match) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => SelectionScreen(
        match: match,
      ),
    );
  }

  const SelectionScreen({
    Key? key,
    required this.match,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sélection des titulaires"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Sélection ${match.nameTeam}"),
        ],
      ),
    );
  }
}