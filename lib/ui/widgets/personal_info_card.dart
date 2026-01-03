import 'package:flutter/material.dart';

class PersonalInfoCard extends StatelessWidget {
  final Map<String, String> infoPairs;

  const PersonalInfoCard({super.key, required this.infoPairs});

  @override
  Widget build(BuildContext context) {
    final keys = infoPairs.keys.toList();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      child: Column(
        children: [
          for (int i = 0; i < keys.length; i += 2) ...[
            Row(
              children: [
                Expanded(
                  child: _InfoColumn(
                    label: keys[i],
                    value: infoPairs[keys[i]] ?? '',
                  ),
                ),
                if (i + 1 < keys.length)
                  Expanded(
                    child: _InfoColumn(
                      label: keys[i + 1],
                      value: infoPairs[keys[i + 1]] ?? '',
                    ),
                  ),
              ],
            ),
            if (i + 2 < keys.length)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Divider(height: 1, color: Color(0xFFE0E0E0)),
              ),
          ],
        ],
      ),
    );
  }
}

class _InfoColumn extends StatelessWidget {
  final String label;
  final String value;

  const _InfoColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
      ],
    );
  }
}