import 'package:flutter/material.dart';
import 'package:tamdan/ui/widgets/personal_info_card.dart';
import 'package:tamdan/ui/widgets/ptofile_header.dart';
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
            Center(child: ProfileHeader(name: user.name, role: user.role)),
            const SizedBox(height: 24),
            
            Center(child: const Text('Personal Info', style: TextStyle( fontSize: 18, color: Color.fromARGB(255, 77, 55, 55)))),
            const SizedBox(height:8,),
            PersonalInfoCard(infoPairs: {
              'Date of birth': '12/12/2002',
              'Gender': 'Male',
              'Role': 'Coach',
              'Experience': '3 Years',
              'Belt Level': 'Coach',
              'Focus on': 'Strength',
            }),
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
