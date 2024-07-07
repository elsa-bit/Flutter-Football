import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/presentation/screens/coach/match/match_screen.dart';
import 'package:flutter_football/presentation/screens/coach/schedule/schedule_screen.dart';
import 'package:flutter_football/presentation/screens/coach/settings/settings_screen.dart';
import 'package:flutter_football/presentation/screens/coach/tchat/tchat_coach_screen.dart';
import 'package:flutter_football/presentation/screens/coach/teams/teams_screen.dart';

import '../../widgets/bottom_nav_bar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 2;
  final screens = [
    const ScheduleScreen(),
    const TchatCoachScreen(),
    const TeamsScreen(),
    const MatchScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((payload) {
      final notification = payload.notification;
      if (notification != null) {
        Flushbar(
          title: notification.title,
          titleColor: currentAppColors.primaryTextColor,
          messageText: Text(
            notification.body!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          messageColor: currentAppColors.primaryTextColor,
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.FLOATING,
          backgroundGradient: LinearGradient(
              colors: [currentAppColors.secondaryColor, Colors.white]),
          icon: Image(
            image: AssetImage('assets/images/CSB_simple.png'),
            width: 30.0,
            height: 30.0,
          ),
          duration: Duration(seconds: 4),
        ).show(context);
      }
    });
  }

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
