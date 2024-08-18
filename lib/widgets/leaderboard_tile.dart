import 'package:flutter/material.dart';

class LeaderboardTile extends StatelessWidget {
  final int rank;
  final String username;
  final int score;
  final bool isCurrentUser;

  const LeaderboardTile({
    Key? key,
    required this.rank,
    required this.username,
    required this.score,
    this.isCurrentUser = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: isCurrentUser ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          '$rank',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(
        username,
        style: TextStyle(fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal),
      ),
      trailing: Text(
        '$score pts',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}