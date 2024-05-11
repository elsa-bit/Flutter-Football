import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../config/app_colors.dart';

class BottomNavBar extends StatefulWidget {
  final Function(int) setIndexOfButton;

  const BottomNavBar({Key? key, required this.setIndexOfButton})
      : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedItem = 1;

  List<BottomNavigationBarItem> navItems = const [
    BottomNavigationBarItem(
        icon: Icon(
          Icons.calendar_month
        ),
        label: 'Programme'),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.sports_soccer,
        ),
        label: 'Équipes'),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.sports_football,
        ),
        label: 'Match'),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.settings,
        ),
        label: 'Paramètres'),
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
