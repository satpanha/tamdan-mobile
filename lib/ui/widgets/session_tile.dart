import 'package:flutter/material.dart';
import 'package:tamdan/data/session_repository.dart';
import 'package:tamdan/ui/widgets/session_header.dart';
import 'package:tamdan/ui/widgets/session_details.dart';

class SessionTile extends StatelessWidget {
  final SessionRecord session;
  final VoidCallback? onTap;

  const SessionTile({super.key, required this.session, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 4,
      color: cs.surface,
      shadowColor: cs.primary.withOpacity(0.10),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        hoverColor: cs.primary.withOpacity(0.06),
        splashColor: cs.primary.withOpacity(0.10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SessionHeader(session: session),
              const Divider(height: 0, thickness: 1, indent: 12, endIndent: 12),
              SessionDetails(payload: session.payload),
            ],
          ),
        ),
      ),
    );
  }


}


