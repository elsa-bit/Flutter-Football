import 'package:flutter/material.dart';

class ContactItem extends StatelessWidget {
  final String firstname;
  final String lastname;
  final String email;
  final String? urlAvatar;

  const ContactItem({
    Key? key,
    required this.firstname,
    required this.lastname,
    required this.email,
    this.urlAvatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(urlAvatar != null
              ? urlAvatar!
              : 'https://pbs.twimg.com/media/ENcoTb_XkAIu64i.jpg'),
        ),
        SizedBox(height: 8),
        Text(
          firstname + " " + lastname,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4),
        Text(
          email,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
