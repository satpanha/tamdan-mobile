import 'package:flutter/material.dart';

class SelectButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const SelectButton({super.key, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? Theme.of(context).colorScheme.primary.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: selected ? Theme.of(context).colorScheme.primary : Colors.grey.shade300),
        ),
        child: Center(child: Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: selected ? Theme.of(context).colorScheme.primary : null)),),
      ),
    );
  }
}
