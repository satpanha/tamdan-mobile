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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Column(
          children: [
            SessionHeader(session: session),
            SessionDetails(payload: session.payload),
          ],
        ),
      ),
    );
  }


}


