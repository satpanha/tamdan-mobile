import 'package:flutter/material.dart';
import 'package:tamdan/utils/mock_data.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = mockUser;

    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 48,
                child: Text(
                  user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(user.name, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            const Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(user.email, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            const Text('Role', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(user.role, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            const Text('Member Since', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('${user.createdDate.day}/${user.createdDate.month}/${user.createdDate.year}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Edit profile coming soon')),
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text('Edit Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
