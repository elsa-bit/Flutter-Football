
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/domain/models/fmi/match_action.dart';
import 'package:flutter_football/utils/extensions/date_time_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GoalActionDetail extends StatelessWidget {
  final GoalAction action;

  const GoalActionDetail({
    Key? key,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          action.goal.fromOpponent ? "But adverse" : "But",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: currentAppColors.primaryTextColor,
          ),
        ),
        if(!action.goal.fromOpponent)
          ...[
            SizedBox(height: 10,),
            Row(
              children: [
                Text(
                  action.createdAt.formatTime(),
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: currentAppColors.secondaryTextColor,
                  ),
                ),
                SizedBox(width: 30,),
                Text(
                  "${action.goal.player.firstname} ${action.goal.player.lastname}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: currentAppColors.primaryTextColor,
                  ),
                ),
                SizedBox(width: 25,),
                Container(
                  width: 30,
                  height: 30,
                  child: SvgPicture.asset(
                    action.assetName,
                    colorFilter: (action.assetTint != null) ? ColorFilter.mode(action.assetTint!, BlendMode.srcIn) : null,
                  ),
                ),
              ],
            )
          ],
      ],
    );
  }
}