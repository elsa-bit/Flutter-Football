import 'package:flutter/material.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/domain/models/conversation.dart';
import 'package:intl/intl.dart';

class ConversationItem extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback? onTap;

  const ConversationItem({
    Key? key,
    required this.conversation,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm');

    return ListTile(
      leading: conversation.avatarUrl != null
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              child: ClipOval(
                child: Image.network(
                  conversation.avatarUrl!,
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              child: ClipOval(
                child: Icon(Icons.groups_outlined,
                    size: 40,
                    fill: 0.1,
                    color: currentAppColors.secondaryColor),
              ),
            ),
      title: Text(
        conversation.playersName != null
            ? conversation.playersName!
            : "Nouvelle conversation",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        formatter.format(conversation.date),
        style: TextStyle(
          fontStyle: FontStyle.italic,
          color: Colors.grey,
        ),
      ),
      onTap: onTap,
    );
  }
}
