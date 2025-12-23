import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String label;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const CustomFormField({super.key, required this.label, this.validator, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
      onChanged: onChanged,
    );
  }
}
