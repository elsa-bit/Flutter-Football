import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Teams"),
      ),
      body: Center(
        child: Text("Welcome to Teams page."),
      ),
    );
  }
}