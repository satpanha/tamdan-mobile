import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tamdan/ui/widgets/session_tile.dart';
import 'package:tamdan/data/session_repository.dart';

void main() {
  testWidgets('SessionTile shows session type and notes when present', (tester) async {
    final session = SessionRecord(
      id: 's1',
      trainingSessionId: 't1',
      athleteId: 'a1',
      sessionType: 'technical',
      payload: {'coachNotes': 'Great progress', 'speed': 4},
      dateTime: DateTime.now(),
    );

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: SessionTile(session: session))));

    // Title should display capitalized session type
    expect(find.textContaining('Technical', findRichText: false), findsOneWidget);

    // Notes should be visible (may appear in multiple places like chips and details)
    expect(find.textContaining('Notes: Great progress'), findsWidgets);
  });
}
