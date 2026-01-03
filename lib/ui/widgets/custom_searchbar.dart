import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String hintText;

  const CustomSearchBar({
    super.key,
    required this.onChanged,
    this.hintText = 'Search...',
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: const Icon(Icons.search, color: Color(0xFF0D47A1)),
        ),
        hintText: hintText,
        filled: true,
        fillColor: const Color.fromARGB(255, 255, 255, 255),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(
            color: Color(0xFFE0E0E0),
          ),
        ),
      ),
      onChanged: onChanged,
    );
  }
}