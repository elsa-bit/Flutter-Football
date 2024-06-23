import 'package:flutter/material.dart';
import 'package:flutter_football/domain/models/match.dart';


class FmiScreen extends StatelessWidget {
  static const String routeName = '/fmi';
  final Match match;

  static Route route(Match match) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => FmiScreen(
        match: match,
      ),
    );
  }

  const FmiScreen({Key? key, required this.match}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FMI"),
      ),
    );
  }
}
