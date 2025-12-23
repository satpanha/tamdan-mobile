import 'package:flutter/material.dart';
import 'package:tamdan/models/athlete.dart';

class AthleteCard extends StatelessWidget {
  final Athlete athlete;
  final VoidCallback onTap;

  const AthleteCard({super.key, required this.athlete, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          child: Text(athlete.name.isNotEmpty ? athlete.name[0].toUpperCase() : "?"),
        ),
        title: Text(athlete.name),
        subtitle: Text("${athlete.beltLevel} • ${athlete.status}"),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
