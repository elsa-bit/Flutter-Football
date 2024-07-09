import 'package:flutter/material.dart' hide Card;
import 'package:flutter_football/domain/models/match_details.dart';

class TacticsScreen extends StatelessWidget {
  static const String routeName = '/tactics';
  final MatchDetails match;

  static Route route(MatchDetails match) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => TacticsScreen(
        match: match,
      ),
    );
  }

  const TacticsScreen({
    Key? key,
    required this.match,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tactique"),
      ),
    );
  }
}