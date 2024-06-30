
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/domain/models/fmi/match_action.dart';
import 'package:flutter_football/utils/extensions/date_time_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReplacementActionDetail extends StatelessWidget {
  final ReplacementAction action;

  const ReplacementActionDetail({
    Key? key,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
            Text(
              action.matchTime,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
                color: currentAppColors.secondaryTextColor,
              ),
            ),
            SizedBox(width: 30,),
            Container(
              width: 30,
              height: 30,
              child: SvgPicture.asset(
                action.assetName,
                colorFilter: ColorFilter.mode(action.assetTint!, BlendMode.srcIn),
              ),
            ),
            SizedBox(width: 25,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${action.replacement.playerOut.firstname} ${action.replacement.playerOut.lastname}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: currentAppColors.primaryTextColor,
                  ),
                ),
                Text(
                  "${action.replacement.playerIn.firstname} ${action.replacement.playerIn.lastname}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
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