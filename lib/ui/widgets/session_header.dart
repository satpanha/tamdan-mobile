import 'package:flutter/material.dart';
import 'package:tamdan/data/session_repository.dart';
import 'package:tamdan/utils/time_utils.dart';

class SessionHeader extends StatelessWidget {
  final SessionRecord session;

  const SessionHeader({super.key, required this.session});

  String _formatDate(DateTime dt) => '${dt.day}/${dt.month}/${dt.year}';

  @override
  Widget build(BuildContext context) {
    final dt = session.dateTime.toLocal();
    final when = timeAgoShort(dt);
    final cs = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      leading: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: cs.primary.withAlpha((0.12 * 255).round()), width: 2),
        ),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: cs.primaryContainer,
          child: Text(session.sessionType.isNotEmpty ? session.sessionType[0].toUpperCase() : '?', style: TextStyle(color: cs.onPrimaryContainer, fontWeight: FontWeight.bold)),
        ),
      ),
      title: Text(session.sessionType.isNotEmpty ? (session.sessionType[0].toUpperCase() + session.sessionType.substring(1)) : session.sessionType),
      subtitle: Text(when),
      trailing: Text(_formatDate(dt), style: TextStyle(fontWeight: FontWeight.bold, color: cs.primary)),
    );
  }
}
