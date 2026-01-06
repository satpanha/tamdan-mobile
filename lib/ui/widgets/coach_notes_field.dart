import 'package:flutter/material.dart';

class CoachNotesField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const CoachNotesField({super.key, required this.controller, this.hint = 'Add coach notes...'});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextFormField(
        controller: controller,
        maxLines: 5,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          hintText: hint,
          labelText: 'Coach Notes',
        ),
      ),
    );
  }
}
