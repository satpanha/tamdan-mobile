import 'package:flutter/material.dart';

class BottomNavWidget extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const BottomNavWidget({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Athletes'),
        BottomNavigationBarItem(icon: Icon(Icons.track_changes), label: 'Tracking'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }
}
