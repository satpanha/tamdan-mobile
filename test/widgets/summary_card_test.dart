import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tamdan/ui/widgets/summary_card.dart';

void main() {
  testWidgets('SummaryCard shows score and progress when score present', (tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: SummaryCard(title: 'Strength', score: 8))));

    expect(find.text('Strength'), findsOneWidget);
    expect(find.text('8 / 10'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });

  testWidgets('SummaryCard shows Not assessed when no score', (tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: SummaryCard(title: 'Conditioning'))));

    expect(find.text('Conditioning'), findsOneWidget);
    expect(find.text('Not assessed'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsNothing);
  });
}
