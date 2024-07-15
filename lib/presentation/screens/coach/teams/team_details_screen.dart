import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/domain/models/team.dart';
import 'package:flutter_football/presentation/blocs/players/players_bloc.dart';
import 'package:flutter_football/presentation/blocs/players/players_event.dart';
import 'package:flutter_football/presentation/screens/coach/teams/team_players_screen.dart';
import 'package:flutter_football/presentation/screens/coach/teams/team_season_details_screen.dart';

class TeamDetailsScreen extends StatefulWidget {
  static const String routeName = 'team-details';
  final Team team;

  const TeamDetailsScreen({super.key, required this.team});

  static Route route(Team team) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => TeamDetailsScreen(
        team: team,
      ),
    );
  }

  @override
  State<TeamDetailsScreen> createState() => _TeamDetailsScreenState();
}

class _TeamDetailsScreenState extends State<TeamDetailsScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    BlocProvider.of<PlayersBloc>(context)
        .add(GetPlayersTeam(teamId: "${widget.team.id}"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(widget.team.name, style: TextStyle(color: AppColors.white)),
        backgroundColor: currentAppColors.secondaryColor,
      ),
      body: Column(
        children: [
          // Add buttons to switch
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _goToSeasonPage();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          (_currentPage == 0)
                              ? AppColors.mediumBlue
                              : currentAppColors.greyColor,
                          currentAppColors.primaryColor,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Saison",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: (_currentPage == 0)
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _goToPlayersPage();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          (_currentPage == 1)
                              ? AppColors.mediumBlue
                              : currentAppColors.greyColor,
                          currentAppColors.primaryColor,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Joueurs",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: (_currentPage == 1)
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              children: [
                // Add season details screen
                TeamSeasonDetailsScreen(
                  team: widget.team,
                ),
                TeamPlayersScreen(),
              ],
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void _goToSeasonPage() {
    if (_currentPage != 0) {
      setState(() {
        _currentPage = 0;
      });
      _pageController.animateToPage(
        0,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToPlayersPage() {
    if (_currentPage != 1) {
      setState(() {
        _currentPage = 1;
      });
      _pageController.animateToPage(
        1,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }
}
