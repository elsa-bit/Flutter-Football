import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/domain/models/team.dart';
import 'package:flutter_football/presentation/blocs/teams/teams_bloc.dart';
import 'package:flutter_football/presentation/blocs/teams/teams_state.dart';
import 'package:flutter_football/presentation/screens/coach/teams/match_history_item.dart';

class TeamSeasonDetailsScreen extends StatelessWidget {
  static const String routeName = 'stats';
  final Team team;

  const TeamSeasonDetailsScreen({super.key, required this.team});

  static Route route(Team team) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => TeamSeasonDetailsScreen(team: team),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamsBloc, TeamState>(
      builder: (context, state) {
        switch (state.status) {
          case TeamStatus.historyLoading:
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.white,
              ),
            );
          default:
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      "Statistiques".toUpperCase(),
                      style: TextStyle(
                        color: currentAppColors.primaryTextColor,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                SectionWidget(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.green,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "Victoires",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              state.wins.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.orange,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "Nuls",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              state.nuls.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.red,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "Défaites",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              state.loses.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      "Historique".toUpperCase(),
                      style: TextStyle(
                        color: currentAppColors.primaryTextColor,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SectionWidget(
                    child: ListView.builder(
                      itemCount: state.teamMatches?.length ?? 0,
                      itemBuilder: (context, index) {
                        final match = state.teamMatches![index];
                        return MatchHistoryItem(match: match);
                      },
                    ),
                  ),
                ),
              ],
            );
        }
      },
    );
  }
}

class SectionWidget extends StatelessWidget {
  final Widget child;

  const SectionWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      color: currentAppColors.sectionColor,
      child: child,
    );
  }
}