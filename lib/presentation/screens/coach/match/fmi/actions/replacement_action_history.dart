
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/domain/models/fmi/match_action.dart';

class ReplacementActionHistory extends StatelessWidget {
  final ReplacementAction action;

  const ReplacementActionHistory({
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
          "Remplacement",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: currentAppColors.primaryTextColor,
          ),
        ),
        SizedBox(height: 10,),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${action.replacement.playerOut.firstname} ${action.replacement.playerOut.lastname}",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                    color: currentAppColors.primaryTextColor,
                  ),
                ),
                Text(
                  "${action.replacement.playerIn.firstname} ${action.replacement.playerIn.lastname}",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                    color: currentAppColors.primaryTextColor,
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}