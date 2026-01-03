import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String role;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 48,
          backgroundColor: Colors.grey[300],
        ),
        const SizedBox(height: 12),
        Text(
          name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          role,
          style: TextStyle(
            fontSize: 15,
            color: Colors.black.withOpacity(0.4),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}