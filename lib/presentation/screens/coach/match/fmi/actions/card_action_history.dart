
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/domain/models/fmi/match_action.dart';

class CardActionHistory extends StatelessWidget {
  final CardAction action;

  const CardActionHistory({
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
          "Carton",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: currentAppColors.primaryTextColor,
          ),
        ),
        SizedBox(height: 5,),
        Text(
          "${action.card.player.firstname} ${action.card.player.lastname}",
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 16,
            color: currentAppColors.primaryTextColor,
          ),
        ),
      ],
    );
  }
}