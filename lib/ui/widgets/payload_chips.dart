import 'package:flutter/material.dart';

class PayloadChips extends StatelessWidget {
  final Map<String, dynamic> payload;

  const PayloadChips({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).colorScheme.surfaceContainerHighest;
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: payload.entries
          .map((e) => Chip(label: Text('${e.key}: ${e.value}'), backgroundColor: bg))
          .toList(),
    );
  }
}
