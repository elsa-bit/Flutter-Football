import 'package:flutter/material.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/domain/models/match.dart';
import 'package:flutter_football/utils/extensions/date_time_extension.dart';

class MatchItem extends StatelessWidget {
  final Match match;
  final VoidCallback? onTap;

  const MatchItem({Key? key, required this.match, this.onTap}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: currentAppColors.primaryVariantColor1,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: (match.win != null) ? ((match.win!) ? AppColors.green.withOpacity(0.4) : AppColors.red.withOpacity(0.4)) : AppColors.black.withOpacity(0.1),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    this.formattedDate(match.date),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  /*if (event.type == 'match' || event.type == 'training')
                    Text(
                      event.team!,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),*/
                ],
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CS Bretigny VS ' + match.opponentName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    if(match.win != null || match.date.isEqualOrBefore(DateTime.now()))
                      Row(
                        children: [
                          Spacer(),
                          Container(
                            alignment: Alignment.bottomRight,
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: (match.idFMI != null) ? AppColors.green.withOpacity(0.4) : AppColors.red.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              (match.idFMI != null) ? "FMI remplie" : "FMI non remplie",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            if(match.win != null || match.date.isEqualOrBefore(DateTime.now())) //if match is finished or should start today
              Container(
                padding: const EdgeInsets.all(10.0),
                  child: Icon((match.idFMI == null) ? Icons.edit : Icons.read_more),
              )
          ],
        ),
      ),
    );
  }

  String formattedDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}";
  }
}