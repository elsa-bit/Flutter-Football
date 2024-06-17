import 'package:flutter/material.dart';
import 'package:flutter_football/presentation/screens/player/home/home_player_screen.dart';
import 'package:flutter_football/presentation/screens/player/settings/settings_screen.dart';
import 'package:flutter_football/presentation/widgets/player_bottom_nav_bar.dart';

class HomePlayer extends StatefulWidget {
  const HomePlayer({Key? key}) : super(key: key);

  @override
  State<HomePlayer> createState() => _HomePlayerState();
}

class _HomePlayerState extends State<HomePlayer> {
  int _currentIndex = 0;
  final screens = [
    HomePlayerScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: screens[_currentIndex],
      ),
      bottomNavigationBar: PlayerBottomNavBar(
        setIndexOfButton: (int value) {
          setState(() {
            _currentIndex = value;
          });
        },
      ),
    );
  }
}