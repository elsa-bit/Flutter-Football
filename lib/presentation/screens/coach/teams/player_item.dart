import 'package:flutter/material.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/config/app_themes.dart';
import 'package:flutter_football/domain/models/player.dart';
import 'package:flutter_football/utils/extensions/string_extension.dart';
import 'package:flutter_svg/svg.dart';

class PlayerItem extends StatelessWidget {
  final Player player;
  final VoidCallback? onTap;

  const PlayerItem({
    Key? key,
    required this.player,
    this.onTap,
  }) : super(key: key);

  // ListTile to add onTap gesture
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(70.0, 10.0, 70.0, 0.0),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.fromLTRB(26.0, 15.0, 15.0, 18.0),
        decoration: BoxDecoration(
          color: currentAppColors.primaryVariantColor1,
          border: Border.all(color: currentAppColors.primaryVariantColor2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${player.firstname} ${player.lastname}",
                  style: TextStyle(
                    color: currentAppColors.primaryTextColor,
                  ),
                ),
                if (player.position != null) ...[
                  Text(
                    "${player.position}".capitalize(),
                    style: AppTextStyle.small
                        .copyWith(color: currentAppColors.secondaryTextColor),
                  ),
                ] else
                  ...[],
              ],
            ),
            Spacer(),
            SvgPicture.asset(
              "assets/arrow.svg",
              colorFilter: ColorFilter.mode(currentAppColors.secondaryTextColor, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }
}
