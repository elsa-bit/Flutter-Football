import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/data/data_sources/shared_preferences_data_source.dart';
import 'package:flutter_football/presentation/blocs/players/players_bloc.dart';
import 'package:flutter_football/presentation/blocs/players/players_event.dart';
import 'package:flutter_football/presentation/blocs/players/players_state.dart';
import 'package:flutter_football/presentation/screens/player/statistic/friend_screen.dart';
import 'package:flutter_football/presentation/screens/player/statistic/ranking_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StatisticScreen extends StatefulWidget {
  static const String routeName = '/player/statistic';

  const StatisticScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const StatisticScreen(),
    );
  }

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PlayersBloc>(context).add(GetPlayerDetails());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Mes stats")),
        backgroundColor: currentAppColors.secondaryColor,
      ),
      body: BlocBuilder<PlayersBloc, PlayersState>(
        builder: (context, state) {
          switch (state.status) {
            case PlayersStatus.loading:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case PlayersStatus.error:
              return Center(
                child: Text(
                  state.error,
                ),
              );
            case PlayersStatus.success:
              if (state.detailsPlayer == null) {
                return const Center(
                  child: Text("Ce joueur n'existe pas"),
                );
              }
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0, bottom: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Icon(
                              Icons.sports_soccer,
                              color: currentAppColors.secondaryColor,
                              size: 70.0,
                            ),
                            Text(
                              state.detailsPlayer!.goal.toString() + " buts",
                              style: TextStyle(fontSize: 28),
                            ),
                          ],
                        ),
                        SizedBox(width: 100),
                        Flexible(
                          child: Column(
                            children: [
                              Icon(
                                Icons.change_circle,
                                color: currentAppColors.secondaryColor,
                                size: 70.0,
                              ),
                              Text(
                                "2",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 28),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 70.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            SvgPicture.asset(
                              'assets/yellow_card.svg',
                              semanticsLabel: 'Yellow Card',
                              height: 70,
                              width: 70,
                            ),
                            Text(
                              state.detailsPlayer!.yellowCard.toString(),
                              style: TextStyle(fontSize: 28),
                            ),
                          ],
                        ),
                        SizedBox(width: 110),
                        Flexible(
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                'assets/red_card.svg',
                                semanticsLabel: 'Red Card',
                                height: 70,
                                width: 70,
                              ),
                              Text(
                                state.detailsPlayer!.redCard.toString(),
                                style: TextStyle(fontSize: 28),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              foregroundColor: WidgetStateProperty.all<Color>(
                                  AppColors.lightBlue),
                            ),
                            onPressed: () => _navigateToRankingScreen(context),
                            child: Text(
                              "Classements",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          ElevatedButton(
                            style: ButtonStyle(
                              foregroundColor: WidgetStateProperty.all<Color>(
                                  AppColors.lightBlue),
                            ),
                            onPressed: () => _navigateToFriendScreen(context),
                            child: Text(
                              "Ajouter des amis",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              );
            default:
              return const Center(
                child: Text("Ce joueur n'existe pas"),
              );
          }
        },
      ),
    );
  }

  void _navigateToRankingScreen(BuildContext context) {
    var sharedPref = SharedPreferencesDataSource();
    var idPlayer = sharedPref.getIdPlayer();
    var idTeams = sharedPref.getTeamsIds();

    RankingScreen.navigateTo(
        context, idPlayer.toString(), utf8.decode(idTeams!));
  }

  void _navigateToFriendScreen(BuildContext context) {
    var sharedPref = SharedPreferencesDataSource();
    var idPlayer = sharedPref.getIdPlayer();

    FriendScreen.navigateTo(context, idPlayer!);
  }
}
