import 'package:flutter/material.dart';
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
      leading: const Icon(Icons.chat),
      title: Text(
        conversation.playersName != null ? conversation.playersName! : "Nouvelle conversation",
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
