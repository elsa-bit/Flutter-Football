import 'package:flutter/material.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/domain/models/match_details.dart';
import 'package:flutter_football/presentation/screens/coach/teams/match_status_widget.dart';
import 'package:flutter_football/utils/extensions/date_time_extension.dart';

class MatchHistoryItem extends StatelessWidget {
  final MatchDetails match;
  final VoidCallback? onTap;

  const MatchHistoryItem({Key? key, required this.match, this.onTap}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: AppColors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Text(
                      match.date.formatTime(),
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16.0,
                        color: currentAppColors.secondaryTextColor,
                      ),
                    ),
                  ),
                  Text(
                    this.formattedDate(match.date),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: currentAppColors.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 25.0),
            getMatchStateWidget(match.win) ?? SizedBox(),
            SizedBox(width: 25.0),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      match.opponentName.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: (match.win == "lose") ? FontWeight.bold : FontWeight.normal,
                        fontSize: 16.0,
                        color: (match.win == "lose") ? currentAppColors.primaryTextColor : currentAppColors.secondaryTextColor,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text(
                      match.nameTeam.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: (match.win == "win") ? FontWeight.bold : FontWeight.normal,
                        fontSize: 16.0,
                        color: (match.win == "win") ? currentAppColors.primaryTextColor : currentAppColors.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  match.opponentGoals.toString(),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: (match.win == "lose") ? FontWeight.bold : FontWeight.normal,
                    fontSize: 16.0,
                    color: (match.win == "lose") ? currentAppColors.primaryTextColor : currentAppColors.secondaryTextColor,
                  ),
                ),
                SizedBox(height: 10,),
                Text(
                  match.teamGoals.toString(),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: (match.win == "win") ? FontWeight.bold : FontWeight.normal,
                    fontSize: 16.0,
                    color: (match.win == "win") ? currentAppColors.primaryTextColor : currentAppColors.secondaryTextColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String formattedDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}";
  }

  Widget? getMatchStateWidget(String? state) {
    if (state == "win") {
      return MatchStatusWidget(title: "V", color: AppColors.green,);
    }
    if (state == "lose") {
      return MatchStatusWidget(title: "D", color: AppColors.red,);
    }
    if (state == "nul") {
      return MatchStatusWidget(title: "N", color: AppColors.orange,);
    }
    return null;
  }
}