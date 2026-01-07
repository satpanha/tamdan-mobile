import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final int? score; // 0..10 or null if not assessed
  final Color? color;

  const SummaryCard({super.key, required this.title, this.score, this.color});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final col = color ?? cs.primary;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: col, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(score != null ? '$score / 10' : 'Not assessed', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 20)),
            const SizedBox(height: 8),
            if (score != null)
              LinearProgressIndicator(value: (score! / 10).clamp(0.0, 1.0), color: col, backgroundColor: col.withAlpha((0.15 * 255).round())),
          ],
        ),
      ),
    );
  }
}
