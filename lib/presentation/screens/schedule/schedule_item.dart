import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/domain/models/event.dart';

class ScheduleItem extends StatelessWidget {
  final Event event;
  final VoidCallback? onTap;

  const ScheduleItem({
    Key? key,
    required this.event,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    IconData iconData;

    switch (event.type) {
      case 'match':
        backgroundColor = Colors.green.withOpacity(0.1);
        iconData = Icons.sports_soccer;
        break;
      case 'training':
        backgroundColor = Colors.grey.withOpacity(0.1);
        iconData = Icons.fitness_center;
        break;
      case 'meeting':
        backgroundColor = currentAppColors.secondaryColor.withOpacity(0.1);
        iconData = Icons.meeting_room;
        break;
      default:
        backgroundColor = Colors.white;
        iconData = Icons.event;
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatTime(event.schedule),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                if (event.type == 'match' || event.type == 'training')
                Text(
                  event.team!,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  if (event.type == 'match')
                    Text(
                      'CS Bretigny VS ' + event.opponentName!,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    )
                  else if (event.type == 'training')
                    Text(
                      event.place!,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    )
                  else if (event.type == 'meeting')
                    Text(
                      event.subject!,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
            Icon(iconData, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  String formatTime(DateTime dateTime) {
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
