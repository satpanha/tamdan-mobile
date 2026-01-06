import 'package:flutter/material.dart';

/// Simple rating bar that emits an integer value using onChanged.
/// Purely presentational; callers manage the state.
class RatingBar extends StatelessWidget {
  final int value; // 0..5
  final ValueChanged<int> onChanged;
  final int max;

  const RatingBar({super.key, required this.value, required this.onChanged, this.max = 5});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(max, (index) {
        final idx = index + 1;
        return IconButton(
          icon: Icon(
            idx <= value ? Icons.star : Icons.star_border,
            color: idx <= value ? Colors.amber : Colors.grey,
          ),
          onPressed: () => onChanged(idx),
          splashRadius: 18,
          visualDensity: VisualDensity.compact,
        );
      }),
    );
  }
}
