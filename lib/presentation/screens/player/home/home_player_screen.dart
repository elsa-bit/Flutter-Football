import 'package:flutter/material.dart';

class HomePlayerScreen extends StatelessWidget {
  static const String routeName = '/player/home';

  const HomePlayerScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const HomePlayerScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Player"),
      ),
      body: Center(
        child: Text("Accueil joueur"),
      ),
    );
  }
}