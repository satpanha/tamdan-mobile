import 'package:flutter/material.dart';
import 'package:tamdan/ui/widgets/custom_app_bar.dart';

/// A reusable scaffold pattern used by all screens per project rules.
/// - AppBar (back + title)
/// - Scrollable content
/// - Optional fixed bottom widget (e.g., Save button)
class BaseScreen extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? bottom;

  const BaseScreen({super.key, required this.title, required this.child, this.bottom});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: title),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: child,
        ),
      ),
      bottomNavigationBar: bottom != null
          ? SafeArea(
              minimum: const EdgeInsets.all(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: bottom,
              ),
            )
          : null,
    );
  }
}
