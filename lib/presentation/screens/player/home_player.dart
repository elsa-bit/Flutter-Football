import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/data/data_sources/shared_preferences_data_source.dart';
import 'package:flutter_football/domain/models/player.dart';
import 'package:flutter_football/presentation/blocs/players/players_bloc.dart';
import 'package:flutter_football/presentation/blocs/players/players_event.dart';
import 'package:flutter_football/presentation/blocs/players/players_state.dart';
import 'package:flutter_football/presentation/screens/player/calendar/calendar_screen.dart';
import 'package:flutter_football/presentation/screens/player/profil/profil_screen.dart';
import 'package:flutter_football/presentation/screens/player/statistic/statistic_screen.dart';
import 'package:flutter_football/presentation/screens/player/tchat/tchat_player_screen.dart';
import 'package:flutter_football/presentation/widgets/player_bottom_nav_bar.dart';

class HomePlayer extends StatefulWidget {
  final SharedPreferencesDataSource sharedPreferences =
      SharedPreferencesDataSource();

  HomePlayer({Key? key}) : super(key: key);

  @override
  State<HomePlayer> createState() => _HomePlayerState();
}

class _HomePlayerState extends State<HomePlayer> {
  Player? detailsPlayer;
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

    var dateTrophy = widget.sharedPreferences.getDateTrophy();
    var newDateTrophy = DateTime.now().toString();
    if (dateTrophy != null) {
      BlocProvider.of<PlayersBloc>(context)
          .add(GetNewTrophy(oldDate: dateTrophy));
    }
    widget.sharedPreferences.saveDateTrophy(newDateTrophy);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 5000), () {
        if (detailsPlayer != null)
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              PageController _pageController = PageController();
              int currentPage = 0;

              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  _pageController.addListener(() {
                    setState(() {
                      currentPage = _pageController.page!.round();
                    });
                  });

                  return SizedBox(
                    height: 300,
                    child: Column(
                      children: [
                        Expanded(
                          child: PageView(
                            controller: _pageController,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50.0, vertical: 30.0),
                                decoration: BoxDecoration(
                                  color: Color(0x91F6E213),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                        "Vous avez marqué ${detailsPlayer!.goal} buts !"),
                                    Text("+${10 * detailsPlayer!.goal}pts"),
                                    SizedBox(height: 20),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50.0, vertical: 30.0),
                                decoration: BoxDecoration(
                                  color: currentAppColors.primaryVariantColor1,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                        "Vous avez écopé de ${detailsPlayer!.redCard + detailsPlayer!.yellowCard} cartons..."),
                                    Text(
                                        "-${(2 * detailsPlayer!.redCard) + detailsPlayer!.yellowCard}pts"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: currentAppColors.primaryVariantColor1,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.all(4.0),
                                width: 10.0,
                                height: 10.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: currentPage == 0
                                      ? currentAppColors.secondaryColor
                                      : Colors.grey,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(4.0),
                                width: 10.0,
                                height: 10.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: currentPage == 1
                                      ? currentAppColors.secondaryColor
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<PlayersBloc, PlayersState>(
        builder: (context, state) {
          switch (state.status) {
            case PlayersStatus.success:
              detailsPlayer = state.detailsPlayer;
              return Center(
                child: screens[_currentIndex],
              );
            default:
              return Center(
                child: screens[_currentIndex],
              );
          }
        },
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
