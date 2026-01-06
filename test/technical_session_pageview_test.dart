import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tamdan/ui/screens/technical_session.dart';
import 'package:tamdan/ui/widgets/rating_bar.dart';
import 'package:tamdan/utils/mock_data.dart';

void main() {
  testWidgets('Technical session keeps per-athlete state when swiping', (tester) async {
    final ids = mockAthletes.take(2).map((e) => e.id).toList();

    await tester.pumpWidget(MaterialApp(
      routes: {
        '/': (context) => Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed('/tech', arguments: {'athleteIds': ids}),
                child: const Text('Open'),
              ),
            ),
        '/tech': (context) => const TechnicalSessionScreen(),
      },
    ));

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    // Should show rating bars
    expect(find.byType(RatingBar), findsWidgets);

    // Tap first star of the first RatingBar
    final starButton = find.byIcon(Icons.star_border).first;
    await tester.tap(starButton);
    await tester.pumpAndSettle();

    // After tapping, a filled star should appear
    expect(find.byIcon(Icons.star), findsWidgets);
  });
}
