import 'package:flutter/material.dart';
import 'package:tamdan/ui/widgets/rating_bar.dart';

class MetricRow extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  const MetricRow({super.key, required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        RatingBar(value: value, onChanged: onChanged),
      ],
    );
  }
}
