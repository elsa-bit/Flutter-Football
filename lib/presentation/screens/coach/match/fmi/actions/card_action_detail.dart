
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/domain/models/fmi/match_action.dart';
import 'package:flutter_football/utils/extensions/date_time_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CardActionDetail extends StatelessWidget {
  final CardAction action;

  const CardActionDetail({
    Key? key,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Carton",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: currentAppColors.primaryTextColor,
          ),
        ),
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
              "${action.card.player.firstname} ${action.card.player.lastname}",
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
              ),
            ),
          ],
        )
      ],
    );
  }
}