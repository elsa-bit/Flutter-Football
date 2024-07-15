import 'package:flutter/material.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/domain/models/team.dart';

class TeamSeasonDetailsScreen extends StatelessWidget {
  static const String routeName = 'season';
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
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: Text(
              "Statistiques".toUpperCase(),
              style: TextStyle(color: currentAppColors.primaryTextColor),
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
                      "0",
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
                      "0",
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
                      "0",
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
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: Text(
              "Historique".toUpperCase(),
              style: TextStyle(color: currentAppColors.primaryTextColor),
            ),
          ),
        ),
        SectionWidget(
          child: Row(
            children: [
              MatchStatusWidget(title: "V", color: AppColors.green,),
              MatchStatusWidget(title: "N", color: AppColors.orange,),
              MatchStatusWidget(title: "V", color: AppColors.green,),
              MatchStatusWidget(title: "V", color: AppColors.green,),
              MatchStatusWidget(title: "D", color: AppColors.red,),
              MatchStatusWidget(title: "N", color: AppColors.orange,),
              MatchStatusWidget(title: "D", color: AppColors.red,),
              MatchStatusWidget(title: "D", color: AppColors.red,),
              MatchStatusWidget(title: "V", color: AppColors.green,),
              MatchStatusWidget(title: "D", color: AppColors.red,),
            ],
          ),
        ),
      ],
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

class MatchStatusWidget extends StatelessWidget {
  final String title;
  final Color? color;

  const MatchStatusWidget({super.key, required this.title, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: AppColors.white,
        ),
      ),
    );
  }
}
