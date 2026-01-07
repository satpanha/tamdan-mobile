import 'package:flutter/material.dart';
import 'package:tamdan/ui/widgets/payload_chips.dart';

class SessionDetails extends StatelessWidget {
  final Map<String, dynamic> payload;

  const SessionDetails({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          PayloadChips(payload: payload),
          if ((payload['coachNotes'] as String?)?.isNotEmpty ?? false) ...[
            const SizedBox(height: 8),
            Text('Notes: ${payload['coachNotes']}', style: const TextStyle(fontStyle: FontStyle.italic)),
          ],
        ],
      ),
    );
  }
}
