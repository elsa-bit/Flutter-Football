import 'package:flutter/material.dart';

class ScheduleScreen extends StatelessWidget {
  static const String routeName = '/';

  const ScheduleScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const ScheduleScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Schedule"),
      ),
      body: Center(
        child: Text("Welcome to Schedule page."),
      ),
    );
  }
}