import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tamdan/routes/app_routes.dart';
import 'package:tamdan/ui/screens/technical_session.dart';
import 'package:tamdan/ui/widgets/athlete_card.dart';

void main() {
  testWidgets('Tracking flow: select session type, pick athletes and start', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(initialRoute: AppRoutes.tracking, routes: AppRoutes.routes));

    // open dropdown and select Technical
    await tester.tap(find.byKey(const Key('sessionDropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Technical').last);
    await tester.pumpAndSettle();

    // select first athlete (mock data present)
    expect(find.text('Select Athletes'), findsOneWidget);
    final athleteTile = find.byType(AthleteCard).first;
    await tester.tap(athleteTile);
    await tester.pumpAndSettle();

    // Start should be enabled now
    final startButton = find.widgetWithText(ElevatedButton, 'Start');
    expect(startButton, findsOneWidget);
    await tester.tap(startButton);
    await tester.pumpAndSettle();

    // Should navigate to technical session
    expect(find.byType(TechnicalSessionScreen), findsOneWidget);
  });
}
