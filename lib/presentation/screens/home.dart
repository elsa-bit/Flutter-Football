import 'package:flutter/material.dart';
import 'package:flutter_football/presentation/screens/schedule/schedule_screen.dart';
import 'package:flutter_football/presentation/screens/settings/settings_screen.dart';
import 'package:flutter_football/presentation/screens/teams/teams_screen.dart';

import '../widgets/bottom_nav_bar.dart';
import 'match/match_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 1;
  final screens = [
    const ScheduleScreen(),
    const TeamsScreen(),
    const MatchScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: screens[_currentIndex],
      ),
      bottomNavigationBar: BottomNavBar(
        setIndexOfButton: (int value) {
          setState(() {
            _currentIndex = value;
          });
        },
      ),
    );
  }
}