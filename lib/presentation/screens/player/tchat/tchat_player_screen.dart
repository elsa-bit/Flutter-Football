import 'package:flutter/material.dart';

class TchatPlayerScreen extends StatefulWidget {
  static const String routeName = '/player/tchat';

  const TchatPlayerScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const TchatPlayerScreen(),
    );
  }

  @override
  State<TchatPlayerScreen> createState() => _TchatPlayerScreenState();
}

class _TchatPlayerScreenState extends State<TchatPlayerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Player"),
      ),
      body: Center(
        child: Text("Tchat joueur"),
      ),
    );
  }
}