import 'package:flutter/material.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/domain/models/player.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RankingItem extends StatelessWidget {
  final Player player;
  final String idPlayer;
  final int index;

  const RankingItem({
    Key? key,
    required this.player,
    required this.idPlayer,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: player.id.toString() == idPlayer
              ? Color(0xa872acde)
              : Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          (index + 1).toString() + ".",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: currentAppColors.primaryTextBlackColor),
        ),
      ),
      title: Text(
        player.firstname + ' ' + player.lastname,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(
                  Icons.sports_soccer,
                  color: currentAppColors.secondaryColor,
                ),
                const SizedBox(width: 10),
                Text(player.goal.toString())
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Container(
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/yellow_card.svg',
                      semanticsLabel: 'Yellow Card',
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(player.yellowCard.toString())
                  ],
                ),
              ),
            ),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/red_card.svg',
                  semanticsLabel: 'Red Card',
                  height: 20,
                  width: 20,
                ),
                const SizedBox(width: 10),
                Text(player.redCard.toString())
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Container(
                child: Row(
                  children: [
                    Icon(
                      Icons.emoji_events,
                      color: Colors.yellow,
                    ),
                    const SizedBox(width: 7),
                    Text(player.trophy.toString())
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
