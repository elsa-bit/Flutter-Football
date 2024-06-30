import 'package:flutter/material.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/domain/models/match_details.dart';
import 'package:flutter_football/utils/extensions/date_time_extension.dart';

class MatchItem extends StatelessWidget {
  final MatchDetails match;
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
              width: 80.0,
              decoration: BoxDecoration(
                color: (match.win != null) ? ((match.win!) ? AppColors.green.withOpacity(0.4) : AppColors.red.withOpacity(0.4)) : AppColors.black.withOpacity(0.1),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    this.formattedDate(match.date),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: AppColors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Text(
                      match.date.formatTime(),
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Text(
                    match.nameTeam,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.0,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
            SizedBox(width: 10.0),
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
                              color: (match.FMICompleted) ? AppColors.green.withOpacity(0.4) : AppColors.red.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              (match.FMICompleted) ? "FMI remplie" : "FMI non remplie",
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
                  child: Icon((!match.FMICompleted) ? Icons.edit : Icons.read_more),
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