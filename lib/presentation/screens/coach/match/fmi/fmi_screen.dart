import 'package:flutter/material.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/domain/models/match_details.dart';
import 'package:flutter_football/presentation/screens/coach/match/fmi/bottom_sheets/cards_bottom_sheet.dart';
import 'package:flutter_football/presentation/screens/coach/match/fmi/bottom_sheets/goal_bottom_sheet.dart';
import 'package:flutter_football/presentation/screens/coach/match/fmi/bottom_sheets/replacement_bottom_sheet.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FmiScreen extends StatelessWidget {
  static const String routeName = '/fmi';
  final MatchDetails match;

  static Route route(MatchDetails match) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => FmiScreen(
        match: match,
      ),
    );
  }

  const FmiScreen({Key? key, required this.match}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FMI"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                "${match.teamGoals} - ${match.opponentGoals}",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 30,
                  color: currentAppColors.primaryTextColor,
                ),
              ),
            ),
            Container(
              //margin: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  Row(
                    children: [
                      Spacer(),
                      FmiAction(
                        onTap: () => {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return GoalBottomSheet();
                            },
                          )
                        },
                        color: AppColors.mediumBlue,
                        imageAsset: "assets/football_icon.svg",
                        title: "But",
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      FmiAction(
                        onTap: () => {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return CardsBottomSheet();
                            },
                          )
                        },
                        color: AppColors.mediumBlue,
                        imageAsset: "assets/cards_icon.svg",
                        title: "Faute",
                      ),
                      Spacer(),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      Spacer(),
                      FmiAction(
                        onTap: () => {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return ReplacementBottomSheet();
                            },
                          )
                        },
                        color: AppColors.mediumBlue,
                        imageAsset: "assets/replacement_icon.svg",
                        title: "Remplacement",
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      FmiAction(
                        onTap: () => {},
                        color: AppColors.mediumBlue,
                        imageAsset: "assets/cards_icon.svg",
                        title: "Faute",
                      ),
                      Spacer(),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FmiAction extends StatelessWidget {
  final VoidCallback? onTap;
  final Color color;
  final String imageAsset;
  final String title;

  const FmiAction({
    Key? key,
    required this.onTap,
    required this.color,
    required this.imageAsset,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        width: 150.0,
        height: 150.0,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                imageAsset,
                height: 80,
                width: 80,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
