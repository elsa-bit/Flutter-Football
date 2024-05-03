import 'package:flutter/material.dart';

class MatchScreen extends StatelessWidget {
  static const String routeName = '/match';

  const MatchScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const MatchScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Match"),
      ),
      body: Center(
        child: Text("Welcome to Match page."),
      ),
    );
  }
}