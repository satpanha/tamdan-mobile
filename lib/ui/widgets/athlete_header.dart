import 'package:flutter/material.dart';
import 'package:tamdan/models/athlete.dart';

class AthleteHeader extends StatelessWidget {
  final Athlete athlete;
  final String? subtitle;

  const AthleteHeader({super.key, required this.athlete, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: cs.primary.withAlpha((0.18 * 255).round()), width: 3),
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: cs.primaryContainer,
                  child: Text(
                    athlete.name.isNotEmpty ? athlete.name[0].toUpperCase() : '?',
                    style: TextStyle(fontWeight: FontWeight.bold, color: cs.onPrimaryContainer, fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      athlete.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: cs.primary.withAlpha((0.08 * 255).round()),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(athlete.beltLevel, style: TextStyle(color: cs.primary, fontWeight: FontWeight.w600)),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(width: 10),
                          Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
                        ]
                      ],
                    )
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
