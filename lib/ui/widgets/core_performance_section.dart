import 'package:flutter/material.dart';
import 'package:tamdan/ui/widgets/metric_section.dart';
import 'package:tamdan/ui/widgets/metric_row.dart';

class CorePerformanceSection extends StatelessWidget {
  final int stamina;
  final int flexibility;
  final int reaction;
  final ValueChanged<int> onStaminaChanged;
  final ValueChanged<int> onFlexibilityChanged;
  final ValueChanged<int> onReactionChanged;

  const CorePerformanceSection({
    super.key,
    required this.stamina,
    required this.flexibility,
    required this.reaction,
    required this.onStaminaChanged,
    required this.onFlexibilityChanged,
    required this.onReactionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return MetricSection(
      title: 'Core performance',
      children: [
        MetricRow(label: 'Stamina', value: stamina, onChanged: onStaminaChanged),
        const SizedBox(height: 8),
        MetricRow(label: 'Flexibility', value: flexibility, onChanged: onFlexibilityChanged),
        const SizedBox(height: 8),
        MetricRow(label: 'Reaction', value: reaction, onChanged: onReactionChanged),
      ],
    );
  }
}
