import 'package:flutter/material.dart';
import 'package:tamdan/models/athlete.dart';

class AthleteHeader extends StatelessWidget {
  final Athlete athlete;
  final String? subtitle;

  const AthleteHeader({super.key, required this.athlete, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                child: Text(athlete.name.isNotEmpty ? athlete.name[0] : '?'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      athlete.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      athlete.beltLevel,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 6),
                      Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
                    ]
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
