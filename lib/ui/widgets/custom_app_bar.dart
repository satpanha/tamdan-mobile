import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Color backgroundColor;
  final Color titleColor;
  final double elevation;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.backgroundColor = const Color.fromARGB(255, 255, 255, 255),
    this.titleColor = const Color(0xFF0D47A1),
    this.elevation = 4,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: titleColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: backgroundColor,
      elevation: elevation,
      shadowColor: Colors.black.withOpacity(0.3),
      actions: actions,
      iconTheme: IconThemeData(color: titleColor),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}