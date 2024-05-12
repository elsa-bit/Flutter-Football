import 'package:flutter/cupertino.dart';
import 'package:flutter_football/config/app_colors.dart';

import '../../../domain/models/team.dart';

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
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.fromLTRB(26.0, 15.0, 15.0, 18.0),
      decoration: BoxDecoration(
        color: currentAppColors.primaryVariantColor1,
        border: Border.all(color: currentAppColors.primaryVariantColor2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        team.name,
        style: TextStyle(
          color: currentAppColors.primaryTextColor,
        ),
      ),
    );
  }

}