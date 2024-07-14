
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/domain/models/fmi/match_action.dart';

class GoalActionHistory extends StatelessWidget {
  final GoalAction action;

  const GoalActionHistory({
    Key? key,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
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
            Text(
              "${action.goal.player?.firstname} ${action.goal.player?.lastname}",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 16,
                color: currentAppColors.primaryTextColor,
              ),
            ),
          ],
      ],
    );
  }
}