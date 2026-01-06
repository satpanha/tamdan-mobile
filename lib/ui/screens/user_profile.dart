import 'package:flutter/material.dart';
import 'package:tamdan/models/user.dart';
import 'package:tamdan/ui/widgets/action_botton.dart';
import 'package:tamdan/ui/widgets/personal_info_card.dart';
import 'package:tamdan/ui/widgets/ptofile_header.dart';
import 'package:tamdan/utils/mock_data.dart';
import 'package:tamdan/ui/screens/edit_user_profile.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late User user;

  @override
  void initState() {
    super.initState();
    user = mockUser;
  }

  void _saveUser(User updatedUser) {
    setState(() {
      user = updatedUser;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: ProfileHeader(name: user.name, role: user.role)),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'Personal Info',
                style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 77, 55, 55)),
              ),
            ),
            const SizedBox(height: 8),
            PersonalInfoCard(infoPairs: {
              'Date of birth': user.formattedDob,
              'Gender': user.gender,
              'Role': user.role,
              'Experience': user.experience,
              'Focus on': user.focusOn,
            }),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ActionButton(
                onPressed: () async {
                  final updatedUser = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditUserProfileScreen(user: user),
                    ),
                  );
                  if (updatedUser != null) {
                    _saveUser(updatedUser);
                  }
                },
                icon: Icons.edit,
                label: 'Edit Profile',
                backgroundColor: const Color(0xFF0D47A1),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}