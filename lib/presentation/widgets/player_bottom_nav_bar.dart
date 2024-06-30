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
        icon: Icon(Icons.calendar_month), label: 'Calendrier'),
    BottomNavigationBarItem(icon: Icon(Icons.forum), label: 'Tchat'),
    BottomNavigationBarItem(icon: Icon(Icons.query_stats), label: 'Mes stats'),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.account_circle
        ),
        label: 'Profil'),
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
