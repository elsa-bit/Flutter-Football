import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/domain/models/team.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TeamItem extends StatelessWidget {
  final Team team;
  final VoidCallback? onTap;

  const TeamItem({
    Key? key,
    required this.team,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(70.0, 10.0, 70.0, 15.0),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.fromLTRB(26.0, 15.0, 15.0, 18.0),
        decoration: BoxDecoration(
          color: currentAppColors.primaryVariantColor1,
          border: Border.all(color: currentAppColors.primaryVariantColor2),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              team.name,
              style: TextStyle(
                color: currentAppColors.primaryTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
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