import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../config/app_colors.dart';

class PlayerBottomNavBar extends StatefulWidget {
  final Function(int) setIndexOfButton;

  const PlayerBottomNavBar({Key? key, required this.setIndexOfButton})
      : super(key: key);

  @override
  State<PlayerBottomNavBar> createState() => _PlayerBottomNavBarState();
}

class _PlayerBottomNavBarState extends State<PlayerBottomNavBar> {
  int _selectedItem = 0;

  List<BottomNavigationBarItem> navItems = const [
    BottomNavigationBarItem(
        icon: Icon(
            Icons.home
        ),
        label: 'Home'),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.settings,
        ),
        label: 'Paramètres'),
    /*BottomNavigationBarItem(
        icon: Icon(
          Icons.sports_football,
        ),
        label: 'Match'),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.settings,
        ),
        label: 'Paramètres'),*/
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedItem = index;
      widget.setIndexOfButton(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: navItems,
      currentIndex: _selectedItem,
      unselectedItemColor: currentAppColors.secondaryTextColor,
      selectedItemColor: currentAppColors.secondaryColor,
      onTap: _onItemTapped,
    );
  }
}
