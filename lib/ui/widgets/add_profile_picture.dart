import 'package:flutter/material.dart';

class AddProfilePicture extends StatelessWidget {
  final String label;

  const AddProfilePicture({super.key, this.label = ''});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 48,
          backgroundColor: Colors.grey[300],
          child: const Icon(Icons.person, size: 48, color: Colors.white),
        ),
        const SizedBox(height: 24),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}