import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? titleColor;
  final double elevation;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.backgroundColor,
    this.titleColor,
    this.elevation = 4,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bg = backgroundColor ?? cs.surface;
    final tc = titleColor ?? cs.primary;

    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: tc,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: bg,
      elevation: elevation,
      shadowColor: Colors.black.withAlpha((0.08 * 255).round()),
      actions: actions,
      iconTheme: IconThemeData(color: tc),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}