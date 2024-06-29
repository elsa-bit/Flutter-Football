import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/presentation/screens/player/calendar/calendar_screen.dart';
import 'package:flutter_football/presentation/screens/player/profil/profil_screen.dart';
import 'package:flutter_football/presentation/screens/player/statistic/statistic_screen.dart';
import 'package:flutter_football/presentation/screens/player/tchat/tchat_player_screen.dart';
import 'package:flutter_football/presentation/widgets/player_bottom_nav_bar.dart';

class HomePlayer extends StatefulWidget {
  const HomePlayer({Key? key}) : super(key: key);

  @override
  State<HomePlayer> createState() => _HomePlayerState();
}

class _HomePlayerState extends State<HomePlayer> {
  int _currentIndex = 0;
  final screens = [
    CalendarScreen(),
    TchatPlayerScreen(),
    StatisticScreen(),
    ProfilScreen(),
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
          message: notification.body,
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
