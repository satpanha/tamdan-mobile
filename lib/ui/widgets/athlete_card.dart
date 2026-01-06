import 'package:flutter/material.dart';
import 'package:tamdan/models/athlete.dart';

class AthleteCard extends StatelessWidget {
  final Athlete athlete;
  final VoidCallback onTap;
  final bool selected;

  const AthleteCard({super.key, required this.athlete, required this.onTap, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: selected ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2) : null,
        ),
        child: Material(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(20),
          elevation: selected ? 3 : 1.5,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey[200],
                    child: const Icon(Icons.account_circle, size: 46, color: Colors.blueAccent),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          athlete.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            children: [
                              TextSpan(text: athlete.beltLevel),
                              const TextSpan(text: ' – Last session: '),
                              TextSpan(
                                text: athlete.status,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}